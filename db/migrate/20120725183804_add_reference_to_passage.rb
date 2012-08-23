class AddReferenceToPassage < ActiveRecord::Migration
  def change
    add_column :passages, :reference, :string
  end
end
