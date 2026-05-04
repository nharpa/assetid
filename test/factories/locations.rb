FactoryBot.define do
  factory :location do
    sequence(:plant_name) { |n| "Plant #{n}" }
    address_line_1 { "1 Water St" }
    suburb { "Riverside" }
    state { "VIC" }
  end
end
