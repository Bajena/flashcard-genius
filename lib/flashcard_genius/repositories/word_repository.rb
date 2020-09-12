class WordRepository < Hanami::Repository
  associations do
    belongs_to :word_lists
    has_many :word_tests
  end

  def for_test(word_list_id: nil, user_id:)
    word_list_condition = "AND word_list_id = #{words.dataset.literal(word_list_id)}" if word_list_id
    # Find a random word that either:
    # a) Has not been tested yet
    # b) Last result was "failed"
    # c) Last result was "medium" and hasn't been checked for more than 1 day
    # d) Last result was "success" and hasn't been checked for more than 4 days
    query = <<-SQL
    SELECT w.* FROM words w
    LEFT OUTER JOIN (
      SELECT * FROM word_tests ORDER BY created_at DESC LIMIT 1
    ) last_test
    ON w.id = last_test.word_id
    INNER JOIN word_lists wl ON wl.id = w.word_list_id
    WHERE wl.user_id = #{words.dataset.literal(user_id)}
    #{word_list_condition}
    AND (
      last_test.id IS NULL
      OR last_test.result = 'success' AND last_test.created_at < NOW() - INTERVAL '4 DAY'
      OR last_test.result = 'medium' AND last_test.created_at < NOW() - INTERVAL '1 DAY'
      OR last_test.result = 'failed'
    )
    ORDER BY RANDOM()
    LIMIT 1
    SQL

    words.read(query).to_a.first
  end
end
