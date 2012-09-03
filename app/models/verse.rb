# == Schema Information
#
# Table name: verses
#
#  id         :integer          not null, primary key
#  book       :string(255)
#  chapter    :integer
#  number     :integer
#  created_at :datetime
#  updated_at :datetime
#  passage_id :integer
#  text       :string(255)
#

class Verse < ActiveRecord::Base
  belongs_to :passage
end
