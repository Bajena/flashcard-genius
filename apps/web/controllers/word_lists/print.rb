module Web
  module Controllers
    module WordLists
      class Print
        include Web::Action
        include Web::Authentication

        COLUMNS = 2
        ROWS = 3

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

          words = word_list.words
          cards_per_page = COLUMNS * ROWS

          pages = (words.length.to_f / cards_per_page).ceil * 2 # * 2 for double sided print


          pdf = Prawn::Document.new
          pdf.font(::File.join(Hanami.public_directory, "DejaVuSans.ttf"))

          (pages - 1).times { pdf.start_new_page }
          pdf.go_to_page(1)

          words.each.with_index do |w, i|
            page = (i / cards_per_page).ceil * 2 + 1 # Pages are numbered from 1
            page_i = i % cards_per_page
            row = page_i / COLUMNS
            col = page_i % COLUMNS

            draw_card(pdf, page, col, row, w.question, w.question_example)
            draw_card(pdf, page + 1, col, row, w.answer, w.answer_example)
          end

          @document = pdf.render
        end

        def draw_card(pdf, page, col, row, text, help_text)
          pdf.go_to_page(page)
          height = pdf.bounds.height
          width = pdf.bounds.width
          top = height
          row_height = height / ROWS
          col_width = width / COLUMNS
          margin_x = 15
          card_height = 150
          card_width = col_width - 2 * margin_x

          x = col * col_width
          x += margin_x
          y = row * row_height

          pdf.bounding_box([x, top - y], width: card_width, height: card_height) do
           pdf.text(text)
           pdf.stroke_bounds
          end
        end
      end
    end
  end
end
