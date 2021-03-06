class WordListRepository < Hanami::Repository
  include InvalidUuidHandling

  associations do
    has_many :words
  end

  def find(*args)
    with_invalid_uuid_handling { super }
  end

  def find_with_words(id)
    with_invalid_uuid_handling do
      aggregate(:words).where(id: id).map_to(WordList).one
    end
  end

  def listing(user_id:)
    word_lists.where(user_id: user_id).select(
      :id,
      :name,
      :created_at,
      words[:id].func { int::count(id).as(:word_count) },
      words[:created_at].func { int::max(created_at).as(:last_word_created_at) }
    ).
      left_join(:words).
      group(:id).
      order(Sequel.desc(:last_word_created_at)).
      map.
      to_a
  end
end
