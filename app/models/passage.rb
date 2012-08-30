require 'rubygems'
require 'rest-client'
require 'rexml/document'

class Passage < ActiveRecord::Base
  has_many :verses
  belongs_to :user

  attr_accessor :user_reference
  attr_reader :reference
  attr_reader :text
  attr_reader :doc

  # reference setter
  def user_reference=(str)
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
    @doc = doc
    puts response
    puts '========================='
    @reference = doc.elements["*/passage/reference"].text
    chapter = doc.elements["*/passage/surrounding-chapters/current"].text
    puts "api ref = #{@reference}"
    doc.elements.each("*/passage/content/verse-unit") do |elt|
        # remove crap
        #e.elements["begin-paragraph"].replace_with REXML::Element.new "p"
        #or
        #elt.elements.delete_all <tag name>, like
        #elt.elements.delete_all "begin-paragraph"
        verse_num = elt.elements['verse-num'].text
        verse_text = elt.children.to_s
        puts "#{chapter}:#{verse_num}: #{verse_text}"
        v = Verse.new
        v.book = chapter
        v.number = verse_num
        v.text = verse_text
        verses << v
    end
  end

  def parse_reference_del
   # bad: make the api call here
   # then when it returns get the verses from the api result
   
    response = RestClient.get 'http://www.esvapi.org/v2/rest/passageQuery', 
      { 
        :params => { 
          :key => 'TEST',
          :passage => @user_reference,
          'include-passage-references' => false,
          'include-footnotes' => false,
          'include-footnote-links' => false,
          'include-headings' => false,
          'include-subheadings' => false,
          'include-audio-link' => false,
          'include-short-copyright' => false
        }
      }

    doc = REXML::Document.new response
    @doc = doc
   # puts response
   # puts '========================='
   # @reference = doc.elements["*/passage/reference"].text
   # chapter = doc.elements["*/passage/surrounding-chapters/current"].text
   # puts "api ref = #{@reference}"
   # doc.elements.each("*/passage/content/verse-unit") do |elt|
   #     verse_num = elt.elements['verse-num'].text
   #     verse_text = elt.text
   #     puts "#{chapter}:#{verse_num}: #{verse_text}"
   #     v = Verse.new
   #     v.book = chapter
   #     v.number = verse_num
   #     v.text = verse_text
   #     verses << v
   # end
  end
end
