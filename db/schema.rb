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

ActiveRecord::Schema.define(:version => 20121228213217) do

  create_table "districts", :force => true do |t|
    t.column "state", :string
    t.column "cd", :string
    t.column "name", :string
    t.column "level", :string
    t.column "the_geom", :multi_polygon
  end

  add_index "districts", ["the_geom"], :name => "index_districts_on_the_geom", :spatial=> true 

  create_table "districts_temp", :primary_key => "gid", :force => true do |t|
    t.column "state", :string, :limit => 2
    t.column "cd", :string, :limit => 2
    t.column "cdtyp", :string, :limit => 1
    t.column "lsad_trans", :string, :limit => 100
    t.column "lsad", :string, :limit => 2
    t.column "name", :string, :limit => 100
    t.column "the_geom", :multi_polygon, :with_z => true, :with_m => true
    t.column "level", :string
    t.column "state_name", :string
  end

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/plugins/spatial_adapter/lib/common_spatial_adapter.rb:44:in `table'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/plugins/spatial_adapter/lib/common_spatial_adapter.rb:42:in `each'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/plugins/spatial_adapter/lib/common_spatial_adapter.rb:42:in `table'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:70:in `tables'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:61:in `each'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:61:in `tables'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:23:in `dump'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/activerecord/lib/active_record/schema_dumper.rb:17:in `dump'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/railties/lib/tasks/databases.rake:246/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/railties/lib/tasks/databases.rake:245:in `open'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/railties/lib/tasks/databases.rake:245/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:205:in `call'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:205:in `execute'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:200:in `each'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:200:in `execute'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:158:in `invoke_with_call_chain'/usr/share/ruby-rvm/rubies/ruby-1.8.7-p370/lib/ruby/1.8/monitor.rb:242:in `synchronize'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:151:in `invoke_with_call_chain'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:144:in `invoke'/media/Data/Agency/Clients/mobileCommons/code/tigress/vendor/rails/railties/lib/tasks/databases.rake:112/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:205:in `call'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:205:in `execute'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:200:in `each'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:200:in `execute'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:158:in `invoke_with_call_chain'/usr/share/ruby-rvm/rubies/ruby-1.8.7-p370/lib/ruby/1.8/monitor.rb:242:in `synchronize'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:151:in `invoke_with_call_chain'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/task.rb:144:in `invoke'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:116:in `invoke_task'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:94:in `top_level'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:94:in `each'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:94:in `top_level'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:133:in `standard_exception_handling'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:88:in `top_level'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:66:in `run'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:133:in `standard_exception_handling'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/lib/rake/application.rb:63:in `run'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/gems/rake-0.9.2.2/bin/rake:33/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/bin/rake:19:in `load'/usr/share/ruby-rvm/gems/ruby-1.8.7-p370@global/bin/rake:19/usr/share/ruby-rvm/gems/ruby-1.8.7-p370/bin/ruby_noexec_wrapper:14

  create_table "lower_districts", :primary_key => "gid", :force => true do |t|
    t.column "statefp", :string, :limit => 2
    t.column "sldlst", :string, :limit => 3
    t.column "namelsad", :string, :limit => 100
    t.column "lsad", :string, :limit => 2
    t.column "chng_type", :string, :limit => 2
    t.column "eff_date", :date
    t.column "new_name", :string, :limit => 100
    t.column "new_code", :string, :limit => 3
    t.column "reltype1", :string, :limit => 2
    t.column "reltype2", :string, :limit => 2
    t.column "reltype3", :string, :limit => 2
    t.column "reltype4", :string, :limit => 2
    t.column "reltype5", :string, :limit => 2
    t.column "rel_ent1", :string, :limit => 8
    t.column "rel_ent2", :string, :limit => 8
    t.column "rel_ent3", :string, :limit => 8
    t.column "rel_ent4", :string, :limit => 8
    t.column "rel_ent5", :string, :limit => 8
    t.column "relate", :string, :limit => 120
    t.column "lsy", :string, :limit => 4
    t.column "name", :string, :limit => 100
    t.column "vintage", :string, :limit => 2
    t.column "funcstat", :string, :limit => 1
    t.column "the_geom", :multi_polygon, :with_z => true, :with_m => true
  end

  create_table "upper_districts", :primary_key => "gid", :force => true do |t|
    t.column "statefp", :string, :limit => 2
    t.column "sldust", :string, :limit => 3
    t.column "namelsad", :string, :limit => 100
    t.column "lsad", :string, :limit => 2
    t.column "chng_type", :string, :limit => 2
    t.column "eff_date", :date
    t.column "new_name", :string, :limit => 100
    t.column "new_code", :string, :limit => 3
    t.column "reltype1", :string, :limit => 2
    t.column "reltype2", :string, :limit => 2
    t.column "reltype3", :string, :limit => 2
    t.column "reltype4", :string, :limit => 2
    t.column "reltype5", :string, :limit => 2
    t.column "rel_ent1", :string, :limit => 8
    t.column "rel_ent2", :string, :limit => 8
    t.column "rel_ent3", :string, :limit => 8
    t.column "rel_ent4", :string, :limit => 8
    t.column "rel_ent5", :string, :limit => 8
    t.column "relate", :string, :limit => 120
    t.column "lsy", :string, :limit => 4
    t.column "name", :string, :limit => 100
    t.column "vintage", :string, :limit => 2
    t.column "funcstat", :string, :limit => 1
    t.column "the_geom", :multi_polygon, :with_z => true, :with_m => true
  end

end
