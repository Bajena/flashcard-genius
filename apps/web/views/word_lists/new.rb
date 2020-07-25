require_relative './with_word_list_form'

module Web
  module Views
    module WordLists
      class New
        include Web::View
        include WithWordListForm
      end
    end
  end
end
