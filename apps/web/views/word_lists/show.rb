module Web
  module Views
    module WordLists
      class Show
        include Web::View

        def page_title
          "#{word_list.name} | Flashcard Genius"
        end
      end
    end
  end
end
