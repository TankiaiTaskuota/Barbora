# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    price { 1.80 }
    amount { 2 }
    full_price { 3.6 }

    order
    product

    trait :second do
      price { 0.2 }
      amount { 4 }
      full_price { 0.8 }
      association :order, factory: %i[order second]
      association :product, factory: %i[product second]
    end
  end
end
