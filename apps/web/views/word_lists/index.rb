module Web
  module Views
    module WordLists
      class Index
        include Web::View

        def page_title
          "Flashcard Genius | My lists"
        end
      end
    end
  end
end
