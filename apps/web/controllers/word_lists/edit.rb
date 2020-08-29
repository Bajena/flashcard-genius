module Web
  module Controllers
    module WordLists
      class Edit
        include Web::Action
        include Web::Authentication

        expose :word_list

        def call(params)
          @word_list = WordListRepository.new.find_with_words(params[:id])

          halt 404 if !@word_list
          halt 404 if !@word_list.anonymous? && @word_list.user_id != current_user&.id
        end
      end
    end
  end
end
