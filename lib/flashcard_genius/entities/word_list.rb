class WordList < Hanami::Entity
  def anonymous?
    user_id.nil?
  end

  def editable_by?(user)
    anonymous? || user_id == user&.id
  end
end
