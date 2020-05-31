FactoryBot.define do
  factory :product do
    name  { 'TEST one' }
    ean { rand(1.9900).to_s }
    type_id { 8 }
  end
end
