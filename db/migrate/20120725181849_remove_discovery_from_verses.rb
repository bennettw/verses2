class RemoveDiscoveryFromVerses < ActiveRecord::Migration
  def up
    remove_column :verses, :discovery
  end

  def down
    add_column :verses, :discovery, :date
  end
end
