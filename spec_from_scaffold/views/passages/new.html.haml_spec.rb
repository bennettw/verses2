require 'spec_helper'

describe "passages/new" do
  before(:each) do
    assign(:passage, stub_model(Passage).as_new_record)
  end

  it "renders new passage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => passages_path, :method => "post" do
    end
  end
end
