module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        include Web::Authentication

        def call(params)
        end
      end
    end
  end
end
