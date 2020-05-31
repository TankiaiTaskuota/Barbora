require 'rails_helper'

RSpec.describe "items/show", type: :view do
  let(:order) { create(:order) }
  let(:product) { create(:product) }

  before(:each) do
    @item = assign(:item, Item.create!(
      product: product,
      order: order,
      price: "9.99",
      amount: "",
      full_price: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
