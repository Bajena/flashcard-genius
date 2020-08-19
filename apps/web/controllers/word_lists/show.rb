module Web
  module Controllers
    module WordLists
      class Show
        include Web::Action
        include Web::Authentication

        expose :word_list

        def call(params)
          @word_list = WordListRepository.new.find_with_words(params[:id])
        end
      end
    end
  end
end
