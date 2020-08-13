module Web
  module Controllers
    module Users
      class Create
        include Web::Action

        params do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:password).filled(:str?)
          end
        end

        def call(params)
          if params.valid?
            # wl = WordListRepository.new.create_with_words(params[:word_list])

            # redirect_to routes.word_list_path(wl.id)
          else
            self.status = 422
          end
        end
      end
    end
  end
end
