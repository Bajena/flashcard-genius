class WordRepository < Hanami::Repository
  associations do
    belongs_to :word_lists
    has_many :word_tests
  end

  def for_test(word_list_id: nil, user_id:)
    word_list_condition = "AND word_list_id = #{words.dataset.literal(word_list_id)}" if word_list_id
    # Find a random word that either:
    # a) Has not been tested yet
    # b) Last result was "failed" and hasn't been checked for more than 15 seconds
    # c) Last result was "unsure" and hasn't been checked for more than 1 day
    # d) Last result was "success" and hasn't been checked for more than 4 days
    query = <<-SQL
    SELECT w.*, wt.created_at as last_test_at
    FROM words w
    LEFT JOIN word_tests wt ON wt.word_id = w.id AND wt.created_at = (SELECT MAX(created_at) FROM word_tests wt2 WHERE wt.word_id = wt2.word_id)
    INNER JOIN word_lists wl ON wl.id = w.word_list_id
    WHERE wl.user_id = #{words.dataset.literal(user_id)}
    #{word_list_condition}
    AND (
      wt.id IS NULL
      OR wt.result = '#{WordTest::RESULT_SUCCESS}' AND DATE(wt.created_at) <= DATE(NOW()) - INTERVAL '#{WordTest::REPETITION_FREQUENCY[WordTest::RESULT_SUCCESS]} SECOND'
      OR wt.result = '#{WordTest::RESULT_UNSURE}' AND DATE(wt.created_at) <= DATE(NOW()) - INTERVAL '#{WordTest::REPETITION_FREQUENCY[WordTest::RESULT_UNSURE]} SECOND'
      OR wt.result = '#{WordTest::RESULT_FAILED}' AND wt.created_at < NOW() - INTERVAL '#{WordTest::REPETITION_FREQUENCY[WordTest::RESULT_FAILED]} SECOND'
    )
    ORDER BY RANDOM()
    LIMIT 1
    SQL

    result = words.read(query).map.first

    return {} unless result
    return { word: Word.new(result), last_test_at: result[:last_test_at] }
  end
end
