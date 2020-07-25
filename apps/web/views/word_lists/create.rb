require_relative './with_word_list_form'

module Web
  module Views
    module WordLists
      class Create
        include Web::View
        include WithWordListForm

        template 'word_lists/new'
      end
    end
  end
end
