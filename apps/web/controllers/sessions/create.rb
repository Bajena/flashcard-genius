module Web
  module Controllers
    module Sessions
      class Create
        include Web::Action

        def call(params)
          result = LoginUser.new.call(params[:user])

          if result.success?
            session[:user_id] = result.user.id
            flash[:success] = "Logged in succesfully"

            redirect_to routes.word_lists_path
          else
            flash[:error] = result.error

            redirect_to routes.login_path
          end
        end
      end
    end
  end
end
