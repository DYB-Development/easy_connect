require "test_helper"
require "open3"

class FreshInstallMigrationsTest < ActiveSupport::TestCase
  MIGRATE_AN_EMPTY_DATABASE = <<~RUBY
    require "bundler/setup"
    require "tmpdir"
    ENV["RAILS_ENV"] = "test"
    require "./test/dummy/config/environment"

    Dir.mktmpdir do |dir|
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: File.join(dir, "fresh.sqlite3"))
      ActiveRecord::Migration.verbose = false
      ActiveRecord::MigrationContext.new("db/migrate").migrate
      abort "no boards table" unless ActiveRecord::Base.connection.table_exists?(:easy_connect_boards)
    end
  RUBY

  test "easy_connect's migrations create the boards table on an empty database" do
    output, status = Open3.capture2e(RbConfig.ruby, "-e", MIGRATE_AN_EMPTY_DATABASE, chdir: EasyConnect::Engine.root.to_s)

    assert status.success?, output
  end
end
