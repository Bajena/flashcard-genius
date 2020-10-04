module Web
  module Controllers
    module WordLists
      class WordListParams < Web::Action::Params
        params do
          required(:word_list).schema do
            required(:name).filled
          end
        end
      end
    end
  end
end
