# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name  { 'TEST one' }
    ean { 'ean:12345EER' }
    type_id { 8 }

    trait :second do
      name  { 'TEST two' }
      ean { 'ean:1299h' }
      type_id { 1 }
    end
  end
end
