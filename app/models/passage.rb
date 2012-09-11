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

  def fetch
    puts "fetch called on passage id #{id}: #{reference}"
    @api ||= Esvapi.new
    @api.query reference
    self.text = parse @api.massage_query_results
    self.save
  end

  private
  def parse(results)
    self.reference = results[:reference]
    text = []
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
