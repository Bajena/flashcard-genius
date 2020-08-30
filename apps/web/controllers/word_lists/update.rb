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
          id = params[:id]
          wl = WordListRepository.new.find(id)

          halt 404 if !wl
          halt 404 if !wl.anonymous? && wl.user_id != current_user&.id

          if params.valid?
            WordListRepository.new.update_with_words(id, params[:word_list])

            redirect_to routes.word_list_path(id)
          else
            self.status = 422
            @word_list = WordList.new({ id: id }.merge(params[:word_list]))
          end
        end
      end
    end
  end
end
