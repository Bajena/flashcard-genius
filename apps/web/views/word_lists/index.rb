module Web
  module Views
    module WordLists
      class Index
        include Web::View

        def page_title
          "My lists | Flashcard Genius"
        end
      end
    end
  end
end
