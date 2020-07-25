module Web
  module Controllers
    module WordLists
      class New
        include Web::Action

        expose :word_list

        def call(params)
          @word_list = WordList.new(
            name: "New list",
            words: [
              Word.new
            ]
          )
        end
      end
    end
  end
end
