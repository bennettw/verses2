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
        # TODO: handle <woc> element that contains text, words of Christ!
        #       handle html escape chars, like &dblquote;
        elt.elements.delete_all 'heading'
        elt.elements.delete_all 'marker'
        elt.elements.delete_all 'begin-paragraph'
        elt.elements.delete_all 'footnote'
        elt.elements.delete_all 'woc/footnote'
        elt.elements.delete_all 'end-paragraph'
        elt.elements.delete_all 'begin-block-indent'
        elt.elements.delete_all 'begin-line'
        elt.elements.delete_all 'end-line'
        elt.elements.delete_all 'end-block-indent'

        verse_num = elt.elements['verse-num'].text
        elt.elements.delete_all 'verse-num' 
        verse_text = elt.children.join " "
        verse_text.gsub! "<woc>", ""
        verse_text.gsub! "</woc>", ""
        puts "#{chapter}:#{verse_num}: #{verse_text}"
        v = Verse.new
        v.book = chapter
        v.number = verse_num
        v.text = verse_text
        verses << v # TODO: throws an error if this object isn't saved 
    end
  end
end
