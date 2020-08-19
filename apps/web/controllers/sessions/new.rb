module Web
  module Controllers
    module Sessions
      class New
        include Web::Action
        include Web::Authentication

        expose :user
        expose :error_messages

        def call(params)
          if current_user
            return redirect_to routes.word_lists_path
          end

          @user = User.new
          @error_messages = []
        end
      end
    end
  end
end
