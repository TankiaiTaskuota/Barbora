# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/new', type: :view do
  before(:each) do
    assign(:product, Product.new(name: 'MyString',
                                 ean: 'MyString',
                                 type_id: 1))
  end

  it 'renders new product form' do
    render

    assert_select 'form[action=?][method=?]', products_path, 'post' do
      assert_select 'input[name=?]', 'product[name]'
      assert_select 'input[name=?]', 'product[ean]'
      assert_select 'input[name=?]', 'product[type_id]'
    end
  end
end
