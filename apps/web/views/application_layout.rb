module Web
  module Views
    class ApplicationLayout
      include Web::Layout

      def page_title
        "Flashcard Genius"
      end
    end
  end
end
