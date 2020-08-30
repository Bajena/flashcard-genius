class WordRepository < Hanami::Repository
  associations do
    belongs_to :word_lists
  end
end
