class WordListRepository < Hanami::Repository
  associations do
    has_many :words
  end

  def create_with_words(data)
    assoc(:words).create(data)
  end

  def find_with_words(id)
    aggregate(:words).where(id: id).map_to(WordList).one
  end
end
