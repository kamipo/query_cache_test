ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # `enlist_fixture_connections` replaces connection pools in non-default handlers
  # by default writer connection pool.
  # We can't test `:reading` connection unless suppressing the effect of the method for now.
  def enlist_fixture_connections
    []
  end
end
