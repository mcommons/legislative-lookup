Rake::TaskManager.class_eval do
  def delete_task(task_name)
    @tasks.delete(task_name.to_s)
  end
  Rake.application.delete_task("db:test:purge")
  Rake.application.delete_task("db:test:prepare")
end

namespace :db do
  namespace :test do
    task :purge => [:environment] do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      ActiveRecord::Migrator.migrate("db/migrate/", 0)

    end

    task :prepare => [:environment, :purge] do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      ActiveRecord::Migration.verbose = false
      ActiveRecord::Migrator.migrate("db/migrate/")


      #unzip test_data.sql, import and then remove sql file.
      config = Rails::Configuration.new
      host   = config.database_configuration[RAILS_ENV]["host"]
      db     = config.database_configuration[RAILS_ENV]["database"]
      user   = config.database_configuration[RAILS_ENV]["username"]

      `tar xvfz db/test_data.sql.tar.gz`
      `psql -h #{host} -d #{db} -f db/test_data.sql -U #{user}`
      [:federal_data_to_temp, :state_data_to_temp, :normalize_temp_districts_names, :temp_to_live, :drop_temp_tables].each do |task|
        Rake::Task["shapefiles_113:#{task}"].execute
      end
      `rm db/test_data.sql`
    end
  end
end