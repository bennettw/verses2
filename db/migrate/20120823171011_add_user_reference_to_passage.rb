class AddUserReferenceToPassage < ActiveRecord::Migration
  def change
    add_column :passages, :user_reference, :string
  end
end
