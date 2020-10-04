module Web
  module Views
    module WordLists
      class Create
        include Web::View

        template 'word_lists/new'
      end
    end
  end
end
