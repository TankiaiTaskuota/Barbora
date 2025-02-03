# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/index', type: :view do
  let(:order) { FactoryBot.create(:order) }
  let(:order_another) { FactoryBot.create(:order, :second) }

  before(:each) do
    order
    order_another
    @orders = Order.all
    @this_month = @orders
    @preveus_month = @orders
  end

  it 'renders a list of orders' do
    render
    assert_select 'tr>td', text: 'Mycurrency'.to_s, count: 2
    assert_select 'tr>td', text: order.price.to_s, count: 1
    assert_select 'tr>td', text: order_another.price.to_s, count: 1
    assert_select 'tr>td', text: order.no.to_s, count: 1
    assert_select 'tr>td', text: order_another.no.to_s, count: 1
  end
end
