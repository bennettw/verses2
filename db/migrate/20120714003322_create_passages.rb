class CreatePassages < ActiveRecord::Migration
  def change
    create_table :passages do |t|
      t.date :discovery

      t.timestamps
    end
  end
end
