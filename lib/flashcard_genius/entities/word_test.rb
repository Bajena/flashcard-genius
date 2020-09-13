# frozen_string_literal: true

class WordTest < Hanami::Entity
  RESULT_FAILED = "failed"
  RESULT_UNSURE = "unsure"
  RESULT_SUCCESS = "success"

  ALLOWED_RESULTS = [RESULT_FAILED, RESULT_UNSURE, RESULT_SUCCESS].freeze

  REPETITION_FREQUENCY = {
    RESULT_FAILED => 15, # seconds
    RESULT_UNSURE => 24 * 3600, # seconds
    RESULT_SUCCESS => 4 * 24 * 3600 # seconds
  }
end
