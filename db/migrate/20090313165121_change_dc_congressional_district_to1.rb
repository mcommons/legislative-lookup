class ChangeDcCongressionalDistrictTo1 < ActiveRecord::Migration
  # It is unclear why the US census think the DC district number should be 98. set it to be 1 for consistency with other states.  
  def self.up
    execute "UPDATE districts set name = '1' WHERE state='11' and level='federal'"
  end

  def self.down
    execute "UPDATE districts set name = '98' WHERE state='11' and level='federal'"
  end
end
