FactoryBot.define do
  factory :word, class: Word do
    question { "Polska" }
    answer { "Polonia" }
    question_example { "Kocham Polskę" }
    answer_example { "Amo Polonia" }

    initialize_with do
      new(attributes)
    end

    to_create do |instance|
      WordRepository.new.create(instance.to_h)
    end
  end
end
