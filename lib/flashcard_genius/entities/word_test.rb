# frozen_string_literal: true

class WordTest < Hanami::Entity
  RESULT_FAILED = "failed"
  RESULT_MEDIUM = "medium"
  RESULT_SUCCESS = "success"

  REPETITION_FREQUENCY = {
    RESULT_FAILED => 0, # days
    RESULT_MEDIUM => 1, # day
    RESULT_SUCCESS => 4 # days
  }
end
