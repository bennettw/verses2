require 'spec_helper'

describe "verses/index" do
  before(:each) do
    assign(:verses, [
      stub_model(Verse,
        :book => "Book",
        :chapter => 1,
        :number => 2
      ),
      stub_model(Verse,
        :book => "Book",
        :chapter => 1,
        :number => 2
      )
    ])
  end

  it "renders a list of verses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Book".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
