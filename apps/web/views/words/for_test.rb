module Web
  module Views
    module Words
      class ForTest
        include Web::View
        format :json

        def render
          response = []
          response << serialized_word if word

          _raw JSON.dump(response)
        end

        private

        def serialized_word
          {
            id: word.id,
            question: word.question,
            answer: word.answer,
            question_example: word.question_example,
            answer_example: word.answer_example
          }
        end
      end
    end
  end
end
