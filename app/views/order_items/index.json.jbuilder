# frozen_string_literal: true

json.array!(@order_items) do |order_item|
  json.extract! order_item, :id, :item_id, :order_id, :price, :amount, :full_price
  json.url order_item_url(order_item, format: :json)
end
