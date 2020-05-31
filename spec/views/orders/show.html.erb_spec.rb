# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/show', type: :view do
  before(:each) do
    @order = assign(:order, create(:order))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(@order.currency)
    expect(rendered).to match(@order.no)
    expect(rendered).to match(/#{@order.discount}/)
    expect(rendered).to match(/#{@order.depozit}/)
    expect(rendered).to match(/#{@order.price}/)
    expect(rendered).to match(/#{@order.maxima}/)
  end
end
