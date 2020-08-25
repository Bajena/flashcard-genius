module Web
  module Controllers
    module WordLists
      class Index
        include Web::Action
        include Web::Authentication

        before do
          unless current_user
            flash[:error] = "You must be logged in to browse word lists"
            redirect_to routes.login_path
          end
        end

        expose :word_lists

        def call(params)
          @word_lists = WordListRepository.new.listing(
            user_id: current_user.id
          )
        end
      end
    end
  end
end
