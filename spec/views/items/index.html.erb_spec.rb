# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/index', type: :view do
  let(:item) { create(:item) }
  let(:item_second) { create(:item, :second) }

  before(:each) do
    assign(:items, [item, item_second])
  end

  it 'renders a list of items' do
    render
    assert_select 'tr>td', text: item.price.to_s, count: 1
    assert_select 'tr>td', text: item_second.price.to_s, count: 1
    assert_select 'tr>td', text: item.amount.to_s, count: 1
    assert_select 'tr>td', text: item_second.amount.to_s, count: 1
  end
end
