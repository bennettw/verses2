class CreateVerses < ActiveRecord::Migration
  def change
    create_table :verses do |t|
      t.string :book
      t.integer :chapter
      t.integer :number
      t.date :discovery

      t.timestamps
    end
  end
end
