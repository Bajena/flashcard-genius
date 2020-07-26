module Web
  module Controllers
    module WordLists
      class Edit
        include Web::Action

        expose :word_list

        def call(params)
          @word_list = WordListRepository.new.find_with_words(params[:id])
        end
      end
    end
  end
end
