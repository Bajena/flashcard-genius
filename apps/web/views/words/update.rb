module Web
  module Views
    module Words
      class Update
        include Web::View

        layout false
        template 'words/create'
      end
    end
  end
end
