class AddPassageIdToVerses < ActiveRecord::Migration
  def change
    add_column :verses, :passage_id, :integer
  end
end
