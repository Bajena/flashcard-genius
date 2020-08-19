require_relative "./word_list_params"

module Web
  module Controllers
    module WordLists
      class Update
        include Web::Action
        include Web::Authentication

        expose :word_list

        params WordListParams

        def call(params)
          if params.valid?
            wl = WordListRepository.new.update_with_words(params[:id], params[:word_list])

            redirect_to routes.word_list_path(wl.id)
          else
            self.status = 422
            @word_list = WordList.new({ id: params[:id] }.merge(params[:word_list]))
          end
        end
      end
    end
  end
end
