module Web
  module Controllers
    module WordLists
      class Print
        include Web::Action
        include Web::Authentication

        expose :word_list

        before :check_list_presence

        def call(params)
          self.headers.merge!(
            {
              'Content-Type' => 'application/pdf',
              # 'Content-Disposition' => "attachment; filename=\"#{filename}\"",
              'Content-Length' => document.length.to_s
            }
          )

          self.body = document
        end

        private

        def check_list_presence
          halt 404 unless word_list
        end

        def word_list
          @word_list ||= WordListRepository.new.find_with_words(params[:id])
        end

        def filename
          "#{word_list.name}.pdf"
        end

        def document
          return @document if defined?(@document)

          pdf = Prawn::Document.new
          pdf.text("Hello World!")

          @document = pdf.render
        end
      end
    end
  end
end
