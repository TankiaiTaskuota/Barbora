json.array!(@orders) do |order|
  json.extract! order, :id, :currency, :price, :discount, :depozit, :no, :maxima
  json.url order_url(order, format: :json)
end
