require 'rubygems'
require 'rest-client'
require 'rexml/document'

class Passage < ActiveRecord::Base
  has_many :verses
  belongs_to :user

  attr_accessor :user_reference
  attr_reader :reference

  # reference setter
  def user_reference=(str)
    # parse out into verses here
    @user_reference = str
    parse_reference 
  end

  def parse_reference
   # bad: make the api call here
   # then when it returns get the verses from the api result
   
    response = RestClient.get 'http://www.esvapi.org/v2/rest/passageQuery', 
      { 
        :params => { 
          :key => 'TEST',
          :passage => @user_reference,
          'output-format' => 'crossway-xml-1.0',
          'include-line-breaks' => false
        }
      }

    doc = REXML::Document.new response
    puts response
    puts '========================='
    @reference = doc.elements["*/passage/reference"].text
    chapter = doc.elements["*/passage/surrounding-chapters/current"].text
    puts "api ref = #{@reference}"
    doc.elements.each("*/passage/content/verse-unit") do |elt|
        verse_num = elt.elements['verse-num'].text
        verse_text = elt.text
        puts "#{chapter}:#{verse_num}: #{verse_text}"
    end
  end
end
