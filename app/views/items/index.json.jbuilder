# frozen_string_literal: true

json.array!(@items) do |item|
  json.extract! item, :id, :product_id, :order_id, :price, :amount, :full_price
  json.url item_url(item, format: :json)
end
