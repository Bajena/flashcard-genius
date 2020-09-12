module Web
  module Controllers
    module Words
      class ForTest
        include Web::Action
        include Web::Authentication

        expose :word

        def call(params)
          self.format = :json

          @word = WordRepository.new.for_test(word_list_id: params[:word_list_id], user_id: current_user.id)
        end
      end
    end
  end
end
