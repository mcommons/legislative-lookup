class UpdateVaDistricts < ActiveRecord::Migration
  def self.up
    config = Rails::Configuration.new
    db     = config.database_configuration[RAILS_ENV]["database"]
    user   = config.database_configuration[RAILS_ENV]["username"]

    # `psql -h127.0.0.1 -d #{db} -f #{RAILS_ROOT}/db/state2010/lower/senate_lower_#{n}.sql -U #{user}`
    # `psql -h127.0.0.1 -d #{db} -f #{RAILS_ROOT}/db/state2010/upper/senate_upper_#{n}.sql -U #{user}`
    
    execute "DELETE FROM districts where state='51' AND level='state_upper'"

    execute "INSERT INTO districts (state, state_name, name, the_geom, level) 
             SELECT '51', 'VA', namelsad, the_geom, 'state_upper' 
             FROM upper_districts"

  end

  def self.down
  end
end


# ----------+------------------------+---------------------------------------------------------------
#  gid      | integer                | not null default nextval('upper_districts_gid_seq'::regclass)
#  statefp  | character varying(2)   | 
#  sldust   | character varying(3)   | 
#  geoid    | character varying(5)   | 
#  namelsad | character varying(100) | 
#  lsad     | character varying(2)   | 
#  lsy      | character varying(4)   | 
#  mtfcc    | character varying(5)   | 
#  funcstat | character varying(1)   | 
#  aland    | double precision       | 
#  awater   | double precision       | 
#  intptlat | character varying(11)  | 
#  intptlon | character varying(12)  | 
#  the_geom | geometry               | 