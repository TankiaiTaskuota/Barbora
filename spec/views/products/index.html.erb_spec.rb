require 'rails_helper'

RSpec.describe "products/index", type: :view do
  before(:each) do
    assign(:products, [
      Product.create!(
        name: "Name",
        ean: "Ean",
        type_id: 2
      ),
      Product.create!(
        name: "Name",
        ean: "Eanii",
        type_id: 2
      )
    ])
  end

  it "renders a list of products" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Ean".to_s, count: 1
    assert_select "tr>td", text: "Eanii".to_s, count: 1
    assert_select "tr>td", text: 2.to_s, count: 2
  end
end
