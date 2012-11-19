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
#  text           :string(255)
#

require 'rubygems'
require 'rest-client'

class Passage < ActiveRecord::Base
  has_many :verses
  belongs_to :user

# Don't do this for fields in teh DB. This will shortcircuit setting fields in the db.
#  attr_accessor :reference, :text, :doc, :discovery

  def user_reference=(ref)
    #self.update_attribute 'user_reference', ref # infinite loop, must call this setter
    write_attribute(:user_reference, ref)
    fetch
  end

  def fetch
    # should this be auto called when the user_reference field is set? why not for now 
    puts "fetch called on passage id #{id}: #{user_reference}"
    @api ||= Esvapi.new
    @api.query user_reference
    self.text = parse @api.massage_query_results
    self.save
  end

  def belongs_to_user(user)
    user.id == self.user_id
  end

  private
  def parse(results)
    self.reference = results[:reference]
    text = [] # could probably use inject here
    results[:verses].each do |verse|
      v = Verse.new
      v.chapter = verse[:chapter]
      v.number = verse[:number]
      v.text = verse[:text]
      text << v.text
    end
    text.join(" ")
  end

end
