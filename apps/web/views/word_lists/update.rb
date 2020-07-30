module Web
  module Views
    module WordLists
      class Update
        include Web::View
        include WithWordListForm

        template 'word_lists/edit'
      end
    end
  end
end