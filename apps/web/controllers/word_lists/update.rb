module Web
  module Controllers
    module WordLists
      class Update
        include Web::Action

        expose :word_list

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

        def call(params)
          if params.valid?
            wl = WordListRepository.new.update_with_words(params[:id], params[:word_list])

            redirect_to routes.word_list_path(wl.id)
          else
            self.status = 422
            @word_list = WordList.new({ id: params[:id] }.merge(params[:word_list]))
          end
        end
      end
    end
  end
end
