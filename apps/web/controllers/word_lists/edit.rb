module Web
  module Controllers
    module WordLists
      class Edit
        include Web::Action
        include Web::Authentication

        expose :word_list

        def call(params)
          @word_list = WordListRepository.new.find(params[:id])

          halt 404 if !@word_list&.editable_by?(current_user)
        end
      end
    end
  end
end
