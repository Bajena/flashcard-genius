module Web
  module Controllers
    module WordLists
      class Create
        class Task
          include Hanami::Validations::Form

          validations do
            required(:name).filled

            required(:words) do
              array? do
                min_size?(1) &
                each do
                  schema do
                    required(:question).filled
                    required(:answer).filled
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
