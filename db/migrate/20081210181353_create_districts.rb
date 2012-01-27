class CreateDistricts < ActiveRecord::Migration
  def self.up
    config = Rails::Configuration.new
    host   = config.database_configuration[RAILS_ENV]["host"]
    db     = config.database_configuration[RAILS_ENV]["database"]
    user   = config.database_configuration[RAILS_ENV]["username"]
    `psql -h #{host} -d #{db} -f #{RAILS_ROOT}/db/congress.sql -U #{user}`
        
    add_index "districts", "the_geom", :spatial=>true
    
    add_column :districts, :state_name, :string
    add_column :districts, :level, :string
    
    execute "UPDATE districts SET level = 'federal'"
    execute "UPDATE districts SET name = '1' where name = 'One'"
    
    District::FIPS_CODES.each do |fips_code, name|
      execute "UPDATE districts SET state_name = '#{name}' WHERE state = '#{fips_code}'"
    end
  end

  def self.down
    drop_table :districts
  end
end
