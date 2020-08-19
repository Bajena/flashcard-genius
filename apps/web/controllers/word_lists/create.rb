require_relative "./word_list_params"

module Web
  module Controllers
    module WordLists
      class Create
        include Web::Action
        include Web::Authentication

        params WordListParams

        expose :word_list

        def call(params)
          if params.valid?
            wl = WordListRepository.new.create_with_words(params[:word_list])

            redirect_to routes.word_list_path(wl.id)
          else
            self.status = 422
            @word_list = WordList.new(params[:word_list])
          end
        end
      end
    end
  end
end
