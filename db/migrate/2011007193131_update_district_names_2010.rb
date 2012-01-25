class UpdateDistrictNames2010 < ActiveRecord::Migration
  def self.up
    # execute "UPDATE districts SET name = split_part(name,'District ',2) WHERE level IN ('state_upper', 'state_lower') AND name LIKE '%District%'"
  end
  def self.down
  
  end
end
