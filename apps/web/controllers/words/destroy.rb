module Web
  module Controllers
    module Words
      class Destroy
        include Web::Action
        include Web::Authentication

        before :check_word_presence
        before :check_list_access

        def call(params)
          WordRepository.new.delete(word.id)

          self.format = :html
          self.body = "ok"
        end

        private

        def check_word_presence
          halt(404) unless word
        end

        def check_list_access
          halt(403) unless word_list.editable_by?(current_user)
        end

        def word_list
          @word_list ||= WordListRepository.new.find(word.word_list_id)
        end

        def word
          @word ||= WordRepository.new.find(params[:id])
        end
      end
    end
  end
end
