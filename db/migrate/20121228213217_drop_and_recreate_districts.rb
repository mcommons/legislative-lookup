class DropAndRecreateDistricts < ActiveRecord::Migration
  puts "This migration will drop districts table if you continue. Press enter to continue, unless you want to preserve something in your districts table."

  STDIN.getc
  drop_table(:districts) if table_exists?(:districts)
  def self.up
    create_table :districts do |t|
      t.string :state, :length => 2
      t.string :cd, :length => 3
      t.string :name, :length => 90
      t.column :the_geom, :multi_polygon
      t.string :level, :length => 255
    end
    add_index :districts, :the_geom, :spatial=>true
  end

  def self.down
    drop_table :districts if table_exists?(:districts)
  end
end
