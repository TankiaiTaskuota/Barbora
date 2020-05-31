# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/edit', type: :view do
  before(:each) do
    @product = assign(:product, Product.create!(name: 'MyString',
                                                ean: 'MyString',
                                                type_id: 1))
  end

  it 'renders the edit product form' do
    render

    assert_select 'form[action=?][method=?]', product_path(@product), 'post' do
      assert_select 'input[name=?]', 'product[name]'
      assert_select 'input[name=?]', 'product[ean]'
      assert_select 'input[name=?]', 'product[type_id]'
    end
  end
end
