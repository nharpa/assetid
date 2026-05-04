FactoryBot.define do
  factory :asset_characteristic_value do
    association :asset
    association :asset_class_characteristic
    value { "test value" }
  end
end
