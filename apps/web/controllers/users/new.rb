module Web
  module Controllers
    module Users
      class New
        include Web::Action
        include Web::Authentication

        expose :user
        expose :error_messages

        def call(params)
          @user = User.new
          @error_messages = []
        end
      end
    end
  end
end
