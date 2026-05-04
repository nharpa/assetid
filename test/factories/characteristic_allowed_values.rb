FactoryBot.define do
  factory :characteristic_allowed_value do
    association :characteristic
    value { "Allowed Value" }
  end
end
