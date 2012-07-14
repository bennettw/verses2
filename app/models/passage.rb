class Passage < ActiveRecord::Base
  has_many :verses
  belongs_to :user
end
