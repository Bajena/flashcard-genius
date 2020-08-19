module Web
  module Controllers
    module Sessions
      class Destroy
        include Web::Action

        def call(params)
          session.delete(:user_id)

          redirect_to routes.word_lists_path
        end
      end
    end
  end
end
