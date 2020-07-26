module Web
  module Views
    module WordLists
      class Update
        include Web::View
        include WithWordListForm

        template 'word_lists/update'
      end
    end
  end
end
