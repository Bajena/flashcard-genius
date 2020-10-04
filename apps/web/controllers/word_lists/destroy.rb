module Web
  module Controllers
    module WordLists
      class Destroy
        include Web::Action
        include Web::Authentication

        before :check_list_presence
        before :check_list_access

        def call(params)
          WordListRepository.new.delete_with_words(word_list.id)

          flash[:success] = "List removed"
          redirect_to routes.root_path
        end

        private

        def check_list_presence
          halt(404) unless word_list
        end

        def check_list_access
          halt(403) unless word_list.editable_by?(current_user)
        end

        def word_list
          @word_list ||= WordListRepository.new.find(params[:id])
        end
      end
    end
  end
end
