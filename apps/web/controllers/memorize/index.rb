module Web
  module Controllers
    module Memorize
      class Index
        include Web::Action
        include Web::Authentication

        before :check_login

        expose :word_list_id

        def call(params)
          @word_list_id = params[:word_list_id]
        end
      end
    end
  end
end
