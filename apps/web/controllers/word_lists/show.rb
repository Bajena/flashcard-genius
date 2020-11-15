module Web
  module Controllers
    module WordLists
      class Show
        include Web::Action
        include Web::Authentication

        expose :word_list

        def call(params)
          @word_list = WordListRepository.new.find_with_words(params[:id])

          # We wanna allow sharing the lists between users.
          # That's why there's only existence check here.
          halt 404 if !@word_list
        end
      end
    end
  end
end
