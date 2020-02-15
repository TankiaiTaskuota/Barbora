# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test 'should get index' do
    get orders_url
    assert_response :success
  end

  test 'should get new' do
    get new_order_url
    assert_response :success
  end

  test 'should create order and call importer' do
    assert_difference('Order.count') do
      file_name = 'SaskaitaFaktura_BRBX631001136853.pdf'
      file = Rails.root.join('test', 'fixtures', 'files', file_name)
      post orders_url, params: { order: { file: fixture_file_upload(file),
                                          currency: @order.currency,
                                          depozit: @order.depozit,
                                          discount: @order.discount,
                                          maxima: @order.maxima,
                                          no: 'new order',
                                          price: @order.price } }
    end

    assert_redirected_to order_path(Order.last)
  end

  test 'should create order' do
    assert_difference('Order.count') do
      post orders_url, params: { order: { currency: @order.currency, depozit: @order.depozit, discount: @order.discount, maxima: @order.maxima, no: 'new order', price: @order.price } }
    end

    assert_redirected_to order_path(Order.last)
  end

  test 'should show order' do
    get order_url(@order)
    assert_response :success
  end

  test 'should get edit' do
    get edit_order_url(@order)
    assert_response :success
  end

  test 'should update order' do
    patch order_url(@order), params: { order: { currency: @order.currency, depozit: @order.depozit, discount: @order.discount, maxima: @order.maxima, no: @order.no, price: @order.price } }
    assert_redirected_to order_path(@order)
  end

  test 'should destroy order' do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_path
  end
end
