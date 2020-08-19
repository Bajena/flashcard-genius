module Web
  module Controllers
    module WordLists
      class Index
        include Web::Action
        include Web::Authentication

        expose :word_lists

        def call(params)
          @word_lists = WordListRepository.new.listing
        end
      end
    end
  end
end
