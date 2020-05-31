require 'rails_helper'

RSpec.describe "orders/new", type: :view do
  before(:each) do
    assign(:order, Order.new(
      currency: "MyString",
      price: "9.99",
      discount: "9.99",
      depozit: "",
      no: "MyString",
      maxima: "9.99"
    ))
  end

  it "renders new order form" do
    render

    assert_select "form[action=?][method=?]", orders_path, "post" do

      assert_select "input[name=?]", "order[currency]"

      assert_select "input[name=?]", "order[price]"

      assert_select "input[name=?]", "order[discount]"

      assert_select "input[name=?]", "order[depozit]"

      assert_select "input[name=?]", "order[no]"

      assert_select "input[name=?]", "order[maxima]"
    end
  end
end
