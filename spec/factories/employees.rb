FactoryBot.define do
  factory :employee do
    sequence(:name) { |n| "John Doe#{n}" }
    sequence(:email) { |n| "john.doe#{n}@example.com" }
    department { "IT" }
    emp_status { "active" }

    trait :admin do
      admin_status { true }
    end
  end
end

