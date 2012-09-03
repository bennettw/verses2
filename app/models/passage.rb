# == Schema Information
#
# Table name: passages
#
#  id             :integer          not null, primary key
#  discovery      :date
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#  reference      :string(255)
#  user_reference :string(255)
#  text           :string(255)
#

require 'rubygems'
require 'rest-client'

class Passage < ActiveRecord::Base
  has_many :verses
  belongs_to :user

  attr_accessor :user_reference
  attr_reader :reference
  attr_reader :text
  attr_reader :doc

  def fetch(api=Esvapi.new)
    api.query @user_reference
    parse api.massage_query_results
  end

  def parse(results)
    @reference = results[:reference]
    @text = String.new
    results[:verses].each do |verse|
      v = Verse.new
      v.chapter = verse[:chapter]
      v.number = verse[:number]
      v.text = verse[:text]
    end
  end
end
