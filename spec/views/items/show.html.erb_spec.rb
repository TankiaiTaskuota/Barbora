# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/show', type: :view do
  let(:item) { create(:item) }

  before(:each) do
    @item = assign(:item, item)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/#{@item.price}/)
    expect(rendered).to match(/#{@item.amount}/)
    expect(rendered).to match(/#{@item.full_price}/)
  end
end
