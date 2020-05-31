require 'rails_helper'

RSpec.describe "orders/show", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
      currency: "Currency",
      price: "9.99",
      discount: "9.99",
      depozit: "",
      no: "No",
      maxima: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Currency/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(/No/)
    expect(rendered).to match(/9.99/)
  end
end
