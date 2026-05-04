FactoryBot.define do
  factory :characteristic do
    sequence(:name) { |n| "Characteristic #{n}" }
    data_type { "string" }

    trait :integer  do; data_type { "integer"  }; end
    trait :decimal  do; data_type { "decimal"  }; end
    trait :boolean  do; data_type { "boolean"  }; end
    trait :date     do; data_type { "date"     }; end
    trait :enum     do; data_type { "enum"     }; end
  end
end
