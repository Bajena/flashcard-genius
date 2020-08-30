require 'hanami/interactor'

class CreateUser
  class Validator
    include Hanami::Validations

    validations do
      required(:email).filled(:str?, format?: /[^@]+@[^\.]+\..+/)
      required(:password).filled(:str?)
    end
  end

  include Hanami::Interactor

  expose :user

  def initialize(repository: UserRepository.new)
    @repository = repository
  end

  def call(params)
    @params = params
    @user = @repository.create(
      email: params[:email], password_digest: password_digest
    )
  rescue Hanami::Model::UniqueConstraintViolationError => e
    raise unless e.message =~ /users_email_key/

    error('Email is already taken')
  end

  private

  def password_digest
    BCrypt::Password.create(@params[:password])
  end

  def valid?(params)
    result = Validator.new(params).validate
    result.errors.each do |attrib, messages|
      messages.each do |message|
        error([attrib.to_s.capitalize, message].join(' '))
      end
    end

    result.success?
  end
end
