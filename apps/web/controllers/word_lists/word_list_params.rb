module Web
  module Controllers
    module WordLists
      class WordListParams < Web::Action::Params
        params do
          required(:word_list).schema do
            required(:name).filled

            required(:words) do
              array? do
                min_size?(1) &
                each do
                  schema do
                    required(:question).filled
                    optional(:question_example) { min_size?(0) }
                    required(:answer).filled
                    optional(:answer_example) { min_size?(0) }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
