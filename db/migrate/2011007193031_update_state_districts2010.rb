class UpdateStateDistricts2010 < ActiveRecord::Migration
  def self.up
    # config = Rails::Configuration.new
    # host   = config.database_configuration[RAILS_ENV]["host"]
    # db     = config.database_configuration[RAILS_ENV]["database"]
    # user   = config.database_configuration[RAILS_ENV]["username"]
    
    # 20081211190903_add_state_legislative_districts.rb shows how to create the sql files this migration needs.

    # execute "DELETE from districts where level IN ('state_lower','state_upper')"
    
    # (1..72).each do | n |
    #   n = n.to_s.rjust(2, '0')
    #   `psql -h #{host} -d #{db} -f #{RAILS_ROOT}/db/state2010/lower/senate_lower_#{n}.sql -U #{user}`
    #   `psql -h #{host} -d #{db} -f #{RAILS_ROOT}/db/state2010/upper/senate_upper_#{n}.sql -U #{user}`
    # end
    
    # execute "INSERT INTO districts (state, cd, lsad, name, lsad_trans, the_geom, level) 
    #          SELECT 31, district_n, district_n, district_n, '', the_geom, 'state_upper' 
    #          FROM upper_districts"

    # District::FIPS_CODES.each do |fips_code, name|
    #   execute "UPDATE districts SET state_name = '#{name}' WHERE state = '#{fips_code}'"
    # end
    
    # drop_table :lower_districts
    # drop_table :upper_districts
  end

  def self.down
  end
end


# congress_production=# INSERT INTO districts (state, cd, lsad, name, lsad_trans, the_geom, level) 
# congress_production-#              SELECT 31, district_n, district_n, district_n, '', the_geom, 'state_upper' 
# congress_production-#              FROM upper_districts;
# INSERT 0 49
# congress_production=# delete from districts where level='state_upper' and state='31';
# DELETE 98
# congress_production=# INSERT INTO districts (state, cd, lsad, name, lsad_trans, the_geom, level) 
# congress_production-#              SELECT 31, district_n, district_n, district_n, '', the_geom, 'state_upper' 
# congress_production-#              FROM upper_districts
# congress_production-# ;
# INSERT 0 49
# congress_production=# UPDATE districts SET state_name = 'NE' where state = '31';
