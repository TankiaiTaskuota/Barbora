# frozen_string_literal: true

json.extract! @order_item, :id, :item_id, :order_id, :price, :amount, :full_price, :created_at, :updated_at
