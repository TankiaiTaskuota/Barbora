# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/new', type: :view do
  before(:each) do
    assign(:order, build(:order))
  end

  it 'renders new order form' do
    render

    assert_select 'form[action=?][method=?]', orders_path, 'post' do
      assert_select 'input[name=?]', 'order[currency]'
      assert_select 'input[name=?]', 'order[price]'
      assert_select 'input[name=?]', 'order[discount]'
      assert_select 'input[name=?]', 'order[depozit]'
      assert_select 'input[name=?]', 'order[no]'
      assert_select 'input[name=?]', 'order[maxima]'
    end
  end
end
