module Web
  module Controllers
    module WordLists
      class Print
        include Web::Action
        include Web::Authentication

        COLUMNS = 2
        ROWS = 4
        CARD_PADDING = 8

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

            draw_card(pdf, page, col, row, w.question, w.question_example, :question)
            draw_card(pdf, page + 1, col, row, w.answer, w.answer_example, :answer)
          end

          @document = pdf.render
        end

        def draw_card(pdf, page, col, row, text, help_text, type)
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
            print_list_name(pdf)
            print_main_text(pdf, text, type)
            print_help_text(pdf, help_text)
            print_footer(pdf)
            pdf.stroke_bounds
          end
        end

        def print_list_name(pdf)
          y = pdf.bounds.height - CARD_PADDING

          pdf.text_box(
            word_list.name,
            at: [CARD_PADDING, y],
            single_line: true,
            size: 10,
            overflow: :shrink_to_fit
          )

          pdf.dash(2)
          pdf.stroke_horizontal_line CARD_PADDING, pdf.bounds.width - CARD_PADDING, at: y - 13
          pdf.undash
        end

        def print_main_text(pdf, text, type)
          y = pdf.bounds.height - CARD_PADDING
          top = y - 25
          box_size = 16
          pdf.fill_color(type == :question ? 'D3D3D3' : 'FFFFFF')
          pdf.fill_and_stroke do
            pdf.rectangle([CARD_PADDING, top], box_size, box_size)
          end
          pdf.fill_color '000000'

          main_text_x = CARD_PADDING + box_size + 5
          pdf.text_box(
            text,
            at: [main_text_x, top - 1],
            size: 16,
            height: 16,
            overflow: :shrink_to_fit,
            width: pdf.bounds.width - main_text_x - CARD_PADDING
          )
        end

        def print_help_text(pdf, text)
          return unless text

          # PADDING + height of the list name + height of the main text
          top = pdf.bounds.height - CARD_PADDING - 25 - 1 - 16

          pdf.text_box(text,
            at: [CARD_PADDING, top],
            size: 12,
            align: :center,
            height: top - CARD_PADDING,
            width: pdf.bounds.width - 2 * CARD_PADDING - 10,
            valign: :center
          )
        end

        def print_footer(pdf)
          y = CARD_PADDING + 6

          pdf.text_box(
            "Printed using FlashcardGenius",
            at: [CARD_PADDING, y],
            single_line: true,
            size: 6,
            overflow: :shrink_to_fit,
            width: pdf.bounds.width - 2 * CARD_PADDING,
            align: :right
          )
        end
      end
    end
  end
end
