module Web
  module Authentication
    def self.included(action)
      action.class_eval do
        expose :current_user
      end
    end

    private

    def authenticated?
      !!current_user
    end

    def current_user
      return @current_user if defined?(@current_user)

      @current_user =
        session[:user_id] ? UserRepository.new.find(session[:user_id]) : nil
    end
  end
end
