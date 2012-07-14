require 'spec_helper'

describe "passages/edit" do
  before(:each) do
    @passage = assign(:passage, stub_model(Passage))
  end

  it "renders the edit passage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => passages_path(@passage), :method => "post" do
    end
  end
end
