require 'rails_helper'

RSpec.describe "items/index", type: :view do
  let(:order) { create(:order) }
  let(:product) { create(:product) }
  let(:product_second) { create(:product, ean: 'random one') }

  before(:each) do
    assign(:items, [
      Item.create!(
        product: product,
        order: order,
        price: "1.99",
        amount: "",
        full_price: "2.99"
      ),
      Item.create!(
        product: product_second,
        order: order,
        price: "3.99",
        amount: "",
        full_price: "2.99"
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "2.99".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "1.99".to_s, count: 1
    assert_select "tr>td", text: "3.99".to_s, count: 1
  end
end
