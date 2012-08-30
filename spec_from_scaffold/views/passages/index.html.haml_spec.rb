require 'spec_helper'

describe "passages/index" do
  before(:each) do
    assign(:passages, [
      stub_model(Passage),
      stub_model(Passage)
    ])
  end

  it "renders a list of passages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
