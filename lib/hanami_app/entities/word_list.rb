class WordList < Hanami::Entity
  def anonymous?
    user_id.nil?
  end
end
