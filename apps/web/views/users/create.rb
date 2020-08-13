module Web
  module Views
    module Users
      class Create
        include Web::View

        template 'users/new'
      end
    end
  end
end
