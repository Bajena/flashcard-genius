require 'hanami/interactor'

class LoginUser
  include Hanami::Interactor

  expose :user

  def initialize(repository: UserRepository.new)
    @repository = repository
  end

  def call(params)
    @params = params
    user = @repository.by_email(params[:email])

    if user && BCrypt::Password.new(user.password_digest) == @params[:password]
      @user = user
    else
      error('Invalid login information')
    end
  end
end
