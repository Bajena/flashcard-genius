FactoryBot.define do
  factory :word_list, class: WordList do
    name { "A list" }
    user_id { nil }

    trait :anonymous do
      user_id { nil }
    end

    trait :with_words do
      transient do
        word_count { 1 }
      end

      after(:create) do |list, evaluator|
        create_list(:word, evaluator.word_count, word_list_id: list.id)
      end
    end

    initialize_with do
      new(attributes)
    end

    to_create do |instance|
      WordListRepository.new.create(instance.to_h)
    end
  end
end
