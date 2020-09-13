module Web
  module Views
    module Learn
      class Index
        include Web::View

        def next_word_path
          return routes.learn_find_word_path unless word_list_id

          routes.learn_find_word_path(word_list_id: word_list_id)
        end
      end
    end
  end
end
