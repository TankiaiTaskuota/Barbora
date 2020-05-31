# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/edit', type: :view do
  before(:each) do
    @item = assign(:item, create(:item))
  end

  it 'renders the edit item form' do
    render

    assert_select 'form[action=?][method=?]', item_path(@item), 'post' do
      assert_select 'input[name=?]', 'item[product_id]'
      assert_select 'input[name=?]', 'item[order_id]'
      assert_select 'input[name=?]', 'item[price]'
      assert_select 'input[name=?]', 'item[amount]'
      assert_select 'input[name=?]', 'item[full_price]'
    end
  end
end
