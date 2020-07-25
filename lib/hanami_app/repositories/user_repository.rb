class UserRepository < Hanami::Repository
  associations do
    has_many :word_lists
  end
end
