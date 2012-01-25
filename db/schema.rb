# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111007193031) do

  create_table "districts", :primary_key => "gid", :force => true do |t|
    t.column "state", :string, :limit => 2
    t.column "cd", :string, :limit => 3
    t.column "lsad", :string, :limit => 2
    t.column "name", :string, :limit => 90
    t.column "lsad_trans", :string, :limit => 50
    t.column "the_geom", :multi_polygon
    t.column "state_name", :string
    t.column "level", :string
    t.column "census_geo_id", :string
  end

  add_index "districts", ["the_geom"], :name => "index_districts_on_the_geom", :spatial=> true 

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /Work/ligerhorn/vendor/plugins/spatial_adapter/lib/common_spatial_adapter.rb:44:in `table'/Work/ligerhorn/vendor/plugins/spatial_adapter/lib/common_spatial_adapter.rb:42:in `each'/Work/ligerhorn/vendor/plugins/spatial_adapter/lib/common_spatial_adapter.rb:42:in `table'/Work/ligerhorn/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:70:in `tables'/Work/ligerhorn/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:61:in `each'/Work/ligerhorn/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:61:in `tables'/Work/ligerhorn/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:23:in `dump'/Work/ligerhorn/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:17:in `dump'/Work/ligerhorn/vendor/rails/railties/lib/tasks/databases.rake:246/Work/ligerhorn/vendor/rails/railties/lib/tasks/databases.rake:245:in `open'/Work/ligerhorn/vendor/rails/railties/lib/tasks/databases.rake:245/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:205:in `call'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:205:in `execute'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:200:in `each'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:200:in `execute'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:158:in `invoke_with_call_chain'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/1.8/monitor.rb:242:in `synchronize'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:151:in `invoke_with_call_chain'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:144:in `invoke'/Work/ligerhorn/vendor/rails/railties/lib/tasks/databases.rake:112/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:205:in `call'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:205:in `execute'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:200:in `each'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:200:in `execute'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:158:in `invoke_with_call_chain'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/1.8/monitor.rb:242:in `synchronize'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:151:in `invoke_with_call_chain'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/task.rb:144:in `invoke'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:112:in `invoke_task'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:90:in `top_level'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:90:in `each'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:90:in `top_level'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:129:in `standard_exception_handling'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:84:in `top_level'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:62:in `run'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:129:in `standard_exception_handling'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/lib/rake/application.rb:59:in `run'/opt/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/rake-0.9.2/bin/rake:32/opt/ree/bin/rake:19:in `load'/opt/ree/bin/rake:19

  create_table "lower_districts", :primary_key => "gid", :force => true do |t|
    t.column "statefp10", :string, :limit => 2
    t.column "sldlst10", :string, :limit => 3
    t.column "geoid10", :string, :limit => 5
    t.column "namelsad10", :string, :limit => 100
    t.column "lsad10", :string, :limit => 2
    t.column "lsy10", :string, :limit => 4
    t.column "mtfcc10", :string, :limit => 5
    t.column "funcstat10", :string, :limit => 1
    t.column "aland10", :float
    t.column "awater10", :float
    t.column "intptlat10", :string, :limit => 11
    t.column "intptlon10", :string, :limit => 12
    t.column "the_geom", :multi_polygon
  end

  create_table "upper_districts", :primary_key => "gid", :force => true do |t|
    t.column "objectid", :integer
    t.column "district_n", :string, :limit => 50
    t.column "district_1", :integer
    t.column "area", :decimal
    t.column "perimeter", :decimal
    t.column "compactnes", :decimal
    t.column "population", :integer
    t.column "voting_age", :integer
    t.column "analysis1", :decimal
    t.column "analysis2", :decimal
    t.column "analysis3", :decimal
    t.column "shape_leng", :decimal
    t.column "shape_area", :decimal
    t.column "rgb", :integer
    t.column "countyspli", :integer
    t.column "precinctsp", :integer
    t.column "remainingb", :integer
    t.column "totalblock", :integer
    t.column "locked", :string, :limit => 50
    t.column "lockedby", :string, :limit => 50
    t.column "labelvalue", :decimal
    t.column "originlaye", :string, :limit => 20
    t.column "originstfi", :string, :limit => 50
    t.column "originla_1", :integer
    t.column "timedate", :string, :limit => 25
    t.column "sid", :string, :limit => 20
    t.column "the_geom", :multi_polygon
  end

end
