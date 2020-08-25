FactoryBot.define do
  factory :word, class: WordRepository do
    question { "Polska" }
    answer { "Polonia" }
    question_example { "Kocham Polskę" }
    answer_example { "Amo Polonia" }

    initialize_with do
      new.create(attributes)
    end

    to_create do |instance|
      # Do nothing, because the instance should already have been saved at build
      # time by the Hanami repository
    end
  end
end
