class WordListRepository < Hanami::Repository
  associations do
    has_many :words
  end

  def create_with_words(data)
    assoc(:words).create(data)
  end

  def update_with_words(id, data)
    transaction do
      assoc(:words).where(word_list_id: id).delete
      WordRepository.new.create(data[:words].map { |w| w.merge(word_list_id: id) })
      update(id, data)
    end
  end

  def find_with_words(id)
    aggregate(:words).where(id: id).map_to(WordList).one
  end
end
