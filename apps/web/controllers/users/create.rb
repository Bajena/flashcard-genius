module Web
  module Controllers
    module Users
      class Create
        include Web::Action

        expose :error_messages
        expose :user

        def call(params)
          result = CreateUser.new.call(params[:user])

          if result.success?
            session[:user_id] = result.user.id

            flash[:info] = "Signed up successfully"
            redirect_to routes.word_lists_path
          else
            @user = User.new
            @error_messages = result.errors
            self.status = 422
          end
        end
      end
    end
  end
end
