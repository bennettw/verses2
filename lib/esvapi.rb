require 'rexml/document'
require 'rest-client'

class Esvapi

  BASE_URL = 'http://www.esvapi.org/v2/rest/passageQuery' 
  API_KEY = 'TEST'

  def query(ref)
    # should this be a factory that makes EsvapiQuery objects, 
    # and those obejcts can be responsible for
    # containing the different fields i care about

    puts "looking up #{ref}"
    @response = RestClient.get BASE_URL,
      { 
        :params => { 
          :key => API_KEY,
          :passage => ref, 
          'output-format' => 'crossway-xml-1.0',
          'include-line-breaks' => false
        }
      }

  end

  def massage_query_results(response=@response)
    doc = REXML::Document.new response
    puts response
    puts '========================='
    reference = doc.elements["*/passage/reference"].text
    chapter = doc.elements["*/passage/surrounding-chapters/current"].text
    puts "api ref = #{reference}"
    results = { :reference  => reference, :verses => [] }
    
    doc.elements.each("*/passage/content/verse-unit") do |elt|
        # TODO:      handle html escape chars, like &dblquote;
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
        elt.elements.delete_all 'begin-chapter'

        verse_num = elt.elements['verse-num'].text
        elt.elements.delete_all 'verse-num' 
        verse_text = elt.children.join " "
        verse_text.gsub!("<woc>", "")
        verse_text.gsub!("</woc>", "")
        verse_text.gsub!("&lquot;", "'")
        verse_text.gsub!("&rquot;", "'")
        verse_text.gsub!("&rdblquot;", "\"")
        verse_text.gsub!("&ldblquot;", "\"")
        verse_text.gsub!("&apos;", "'")
        puts "#{chapter}:#{verse_num}: #{verse_text}"
        results[:verses] << { :chapter => chapter, :number => verse_num, :text => verse_text }
    end

    results
  end
end
