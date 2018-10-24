# Support the new rails 5 migration syntax, while retaining backwards
# compatibility with the old sytax.
#
RailsMigration = if Gem::Version.new(ActiveRecord::VERSION::STRING) >= Gem::Version.new("5")
  ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
else
  ActiveRecord::Migration
end
