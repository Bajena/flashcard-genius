module Web
  module Views
    module WordLists
      class Show
        include Web::View

        def page_title
          "Flashcard Genius - #{word_list.name}"
        end
      end
    end
  end
end
