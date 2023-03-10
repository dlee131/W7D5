class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login!(user)
        session[:session_token] = user.reset_session_token!
    end

    def logout!
        if logged_in?
            current_user.reset_session_token!
            session[:session_token] = nil
            @current_user = nil
        end
    end

    def logged_in?
        !!current_user
    end

    def required_logged_in
        if !logged_in?
            redirect_to
        end
    end

    def require_logged_out
        if logged_in?
            redirect_to
        end
    end

end
