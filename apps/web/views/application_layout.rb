module Web
  module Views
    class ApplicationLayout
      include Web::Layout

      def page_title
        "Flashcard Genius | Create, Print & Learn for Free"
      end

      def page_description
        "Flashcard Genius is an application that lets you create, memorize and print lists of flashcards for free!"
      end
    end
  end
end
