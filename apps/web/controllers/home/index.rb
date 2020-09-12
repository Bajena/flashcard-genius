module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include Web::Authentication

        before do
          redirect_to routes.word_lists_path if current_user
        end

        def call(params)
        end
      end
    end
  end
end
