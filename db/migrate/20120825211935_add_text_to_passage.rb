class AddTextToPassage < ActiveRecord::Migration
  def change
    add_column :passages, :text, :string
  end
end
