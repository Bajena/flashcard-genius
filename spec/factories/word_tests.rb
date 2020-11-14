FactoryBot.define do
  factory :word_test, class: WordTestRepository do
    word_id { nil }
    result { "success" }

    initialize_with do
      new.create(attributes)
    end

    to_create do |instance|
      # Do nothing, because the instance should already have been saved at build
      # time by the Hanami repository
    end
  end
end
