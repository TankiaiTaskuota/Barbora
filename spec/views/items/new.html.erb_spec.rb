# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/new', type: :view do
  before(:each) do
    assign(:item, FactoryBot.build(:item))
  end

  it 'renders new item form' do
    render

    assert_select 'form[action=?][method=?]', items_path, 'post' do
      assert_select 'input[name=?]', 'item[product_id]'
      assert_select 'input[name=?]', 'item[order_id]'
      assert_select 'input[name=?]', 'item[price]'
      assert_select 'input[name=?]', 'item[amount]'
      assert_select 'input[name=?]', 'item[full_price]'
    end
  end
end
