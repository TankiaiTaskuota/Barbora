require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    Order.create!(
      currency: "Currency",
      price: "1.99",
      discount: "2.99",
      depozit: "",
      no: "No",
      maxima: "3.99"
    )
    Order.create!(
      currency: "Currency",
      price: "1.99",
      discount: "4.99",
      depozit: "",
      no: "No2",
      maxima: "5.99"
    )
    @orders = Order.all
    @this_month = @orders
    @preveus_month = @orders
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", text: "Currency".to_s, count: 2
    assert_select "tr>td", text: "1.99".to_s, count: 2
    assert_select "tr>td", text: "2.99".to_s, count: 1
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "No".to_s, count: 1
    assert_select "tr>td", text: "No2".to_s, count: 1
    assert_select "tr>td", text: "5.99".to_s, count: 1
  end
end
