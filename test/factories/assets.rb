FactoryBot.define do
  factory :asset do
    sequence(:asset_tag) { |n| "ASSET-#{n.to_s.rjust(3, '0')}" }
    name { "Test Asset" }
    association :asset_class
    association :location
    status { "active" }
  end
end
