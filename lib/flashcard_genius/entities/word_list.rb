class WordList < Hanami::Entity
  def anonymous?
    user_id.nil?
  end

  def editable_by?(current_user)
    anonymous? || user_id == current_user&.id
  end

  def learnable_by?(current_user)
    !!(current_user && user_id && current_user.id == user_id)
  end
end
