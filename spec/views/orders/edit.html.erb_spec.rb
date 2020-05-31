# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/edit', type: :view do
  before(:each) do
    @order = assign(:order, create(:order))
  end

  it 'renders the edit order form' do
    render

    assert_select 'form[action=?][method=?]', order_path(@order), 'post' do
      assert_select 'input[name=?]', 'order[currency]'
      assert_select 'input[name=?]', 'order[price]'
      assert_select 'input[name=?]', 'order[discount]'
      assert_select 'input[name=?]', 'order[depozit]'
      assert_select 'input[name=?]', 'order[no]'
      assert_select 'input[name=?]', 'order[maxima]'
    end
  end
end
