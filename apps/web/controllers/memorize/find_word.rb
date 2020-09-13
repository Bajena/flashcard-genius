module Web
  module Controllers
    module Memorize
      class FindWord
        include Web::Action
        include Web::Authentication

        before :check_login

        expose :word
        expose :last_test_at

        def call(params)
          result = WordRepository.new.for_test(
            word_list_id: params[:word_list_id],
            user_id: current_user.id
          )

          @word = result[:word]
          @last_test_at = result[:last_test_at]
        end
      end
    end
  end
end
