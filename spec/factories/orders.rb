FactoryBot.define do
  factory :order do
    no { rand(1.99).to_s }
    price { 8 }
  end
end
