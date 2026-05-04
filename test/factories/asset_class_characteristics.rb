FactoryBot.define do
  factory :asset_class_characteristic do
    association :asset_class
    association :characteristic
    display_order { 10 }
    required { false }
  end
end
