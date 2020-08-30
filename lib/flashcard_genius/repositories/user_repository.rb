class UserRepository < Hanami::Repository
  associations do
    has_many :word_lists
  end

  def by_email(email)
    users.where(email: email).as(:entity).one
  end
end
