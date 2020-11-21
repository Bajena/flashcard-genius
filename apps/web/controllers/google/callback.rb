module Web
  module Controllers
    module Google
      class Callback
        include Web::Action

        def call(params)
          if email
            repo = UserRepository.new
            u = repo.by_email(email) || create_user

            session[:user_id] = u.id

            redirect_to routes.root_path
          else
            flash[:error] = "Google login failed"
            redirect_to routes.login_path
          end
        end

        private

        def create_user
          UserRepository.new.create(
            email: email,
            password_digest: BCrypt::Password.create(SecureRandom.hex(32))
          )
        end

        def email
          return if !auth || !auth["info"] || !auth["info"]["email"]

          auth["info"]["email"]
        end

        def auth
          request.env["omniauth.auth"]
        end
      end
    end
  end
end
