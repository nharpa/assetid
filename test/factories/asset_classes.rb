FactoryBot.define do
  factory :asset_class do
    sequence(:name) { |n| "Asset Class #{n}" }
    description { "A test asset class." }
  end
end
