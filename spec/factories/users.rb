FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { "123456" }

    trait :with_password do
      transient do
        password { "pass" }
      end

      password_digest { BCrypt::Password.create(password) }
    end

    initialize_with do
      new(attributes)
    end

    to_create do |instance|
      UserRepository.new.create(instance.to_h)
    end
  end
end
