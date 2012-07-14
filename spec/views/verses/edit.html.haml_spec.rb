require 'spec_helper'

describe "verses/edit" do
  before(:each) do
    @verse = assign(:verse, stub_model(Verse,
      :book => "MyString",
      :chapter => 1,
      :number => 1
    ))
  end

  it "renders the edit verse form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => verses_path(@verse), :method => "post" do
      assert_select "input#verse_book", :name => "verse[book]"
      assert_select "input#verse_chapter", :name => "verse[chapter]"
      assert_select "input#verse_number", :name => "verse[number]"
    end
  end
end
