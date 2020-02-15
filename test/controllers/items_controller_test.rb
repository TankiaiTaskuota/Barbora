# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
    @product = products(:one)
    @order = orders(:one)
  end

  test 'should get index' do
    get items_url
    assert_response :success
  end

  test 'should get new' do
    get new_item_url
    assert_response :success
  end

  test 'should create item' do
    assert_difference('Item.count') do
      post items_url, params: { item: { amount: 10, full_price: 5, order_id: @order.id, price: 10, product_id: @product.id } }
    end

    assert_redirected_to item_path(Item.last)
  end

  test 'should show item' do
    get item_url(@item)
    assert_response :success
  end

  test 'should get edit' do
    get edit_item_url(@item)
    assert_response :success
  end

  test 'should update item' do
    patch item_url(@item), params: { item: { amount: @item.amount + 50, order_id: @order.id, price: 10, product_id: @product.id } }
    assert_redirected_to item_path(@item)
  end

  test 'should destroy item' do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_path
  end
end
