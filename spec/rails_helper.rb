require "spec_helper"

require "active_support"
require "active_model"
require "active_record"
require "event_sourcing/active_record"

require "support/migration"
require "support/rails/test_models"

MIGRATIONS_PATH = [File.expand_path(File.join("rails", "migrations"), __dir__)].freeze

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      host: ENV["POSTGRES_HOST"] || "localhost",
      port: ENV["POSTGRES_PORT"] || 5432,
      username: ENV["POSTGRES_USER"],
      password: ENV["POSTGRES_PASSWORD"],
      adapter: "postgresql",
      database: "event_sourcing_test"
    )

    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS schema_migrations")
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS user_events")
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS users")
    ActiveRecord::MigrationContext.new(MIGRATIONS_PATH).migrate
  end
end
