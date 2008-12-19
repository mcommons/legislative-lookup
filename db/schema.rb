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

ActiveRecord::Schema.define(:version => 20081211190903) do

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

end
