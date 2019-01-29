class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    # (2)
    #
    # The following `@post.update(post_params)` is happened on the `:writing` connection,
    # and then clear the cache on the `:writing` connection.
    # The cache on the `:reading` connection is still remained.
    if @post.update(post_params)
      # (3)
      #
      # If use the `:reading` connection after update queries are executed on the `:writing` connection,
      # the query cache on the `:reading` connection is already staled,
      # people need to care about that case by themselves for now.
      set_post

      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      # (1)
      #
      # All connection pools are enabling query cache by default.
      # So the following `Post.find(params[:id])` makes the cache on the `:reading` connection.
      #
      # https://github.com/rails/rails/blob/536a190ab3690810a3b342b897f2585c4971229d/activerecord/lib/active_record/query_cache.rb#L31-L33
      Post.connected_to(role: :reading) do
        @post = Post.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
