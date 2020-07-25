module Web
  module Views
    module WordLists
      module WithWordListForm
        def self.included(view)
          view.class_eval do
            def render
              word_list.words.unshift(Word.new(id: 0))

              r = super

              word_list.words.delete(1)

              raw r
            end
          end
        end
      end
    end
  end
end
