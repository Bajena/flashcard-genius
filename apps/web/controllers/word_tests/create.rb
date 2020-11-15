module Web
  module Controllers
    module WordTests
      class Create
        include Web::Action
        include Web::Authentication

        before :check_login
        before :load_word
        before :check_list_access
        before :check_result

        def call(params)
          WordTestRepository.new.create(word_id: @word.id, result: params[:result])

          self.body = "ok"
        end

        private

        def check_login
          return if current_user

          halt 403
        end

        def load_word
          @word = WordRepository.new.find(params[:word_id])

          halt 404 unless @word
        end

        def check_list_access
          word_list = WordListRepository.new.find(@word.word_list_id)
          return if word_list.user_id == current_user.id

          halt 404
        end

        def check_result
          return if WordTest::ALLOWED_RESULTS.include?(params[:result])

          halt 422
        end
      end
    end
  end
end
