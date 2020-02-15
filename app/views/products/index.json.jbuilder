# frozen_string_literal: true

json.array!(@products) do |product|
  json.extract! product, :id, :name, :ean, :type_id
  json.url product_url(product, format: :json)
end
