module Web
  module Controllers
    module Words
      class Update
        include Web::Action
        include Web::Authentication

        expose :word
        expose :word_list

        before :check_word_presence
        before :check_list_access

        params do
          required(:word).schema do
            required(:question).filled
            optional(:question_example) { min_size?(0) }
            required(:answer).filled
            optional(:answer_example) { min_size?(0) }
          end
        end

        def call(params)
          self.format = :html

          if params.valid?
            @word = WordRepository.new.update(params[:id], params[:word])
          else
            self.status = 422
          end
        end

        private

        def check_word_presence
          word = load_word

          halt(404) unless word
        end

        def check_list_access
          word_list = load_word_list

          halt(403) unless word_list.editable_by?(current_user)
        end

        def load_word_list
          @word_list = WordListRepository.new.find(@word.word_list_id)
        end

        def load_word
          @word = WordRepository.new.find(params[:id])
        end
      end
    end
  end
end
