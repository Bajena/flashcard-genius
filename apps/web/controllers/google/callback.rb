module Web
  module Controllers
    module Google
      class Callback
        include Web::Action

        def call(params)
          repo = UserRepository.new
          u = repo.by_email(email) || create_user

          session[:user_id] = u.id

          redirect_to routes.root_path
        end

        private

        def create_user
          UserRepository.new.create(
            email: email,
            password_digest: BCrypt::Password.create(SecureRandom.hex(32))
          )
        end

        def email
          request.env["omniauth.auth"]["info"]["email"]
        end
      end
    end
  end
end
