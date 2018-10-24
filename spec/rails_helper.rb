require "spec_helper"

require "active_support"
require "active_model"
require "active_record"
require "event_sourcing/rails"

require "support/migration"
require "support/rails/test_models"

MIGRATIONS_PATH = [File.expand_path(File.join("rails", "migrations"), __dir__)].freeze

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "event_sourcing_test")
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS schema_migrations")
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS user_events")
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS users")
    if ActiveRecord.version.release < Gem::Version.new("5.2.0")
      ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)
    else
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH).migrate
    end
  end
end
