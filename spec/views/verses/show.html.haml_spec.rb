require 'spec_helper'

describe "verses/show" do
  before(:each) do
    @verse = assign(:verse, stub_model(Verse,
      :book => "Book",
      :chapter => 1,
      :number => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Book/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
