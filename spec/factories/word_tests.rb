FactoryBot.define do
  factory :word_test, class: WordTest do
    word_id { nil }
    result { "success" }

    initialize_with do
      new(attributes)
    end

    to_create do |instance|
      WordTestRepository.new.create(instance.to_h)
    end
  end
end
