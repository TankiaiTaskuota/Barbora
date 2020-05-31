# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    no { 'first' }
    price { 9.99 }
    currency { 'Mycurrency' }
    discount { 4.99 }
    depozit { 2.6 }
    maxima { 0.12 }

    trait :second do
      no { 'second' }
      price { 62.32 }
      currency { 'Mycurrency' }
      discount { 0.40 }
      depozit { 2.65 }
      maxima { 4.12 }
    end
  end
end
