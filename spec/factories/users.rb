FactoryBot.define do
  factory :user, class: UserRepository do
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { "123456" }

    initialize_with do
      new.create(attributes)
    end

    to_create do |instance|
      # Do nothing, because the instance should already have been saved at build
      # time by the Hanami repository
    end
  end
end
