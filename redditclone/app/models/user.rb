class User < ApplicationRecord

    validates :username, :session_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true}
    validates :password_digest, presence: true

    attr_reader :password

    before_validation :ensure_session_token

    def password=(new_pass)
       @password = new_pass
      self.password_digest = BCrypt:: Password.create(new_pass)
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!  
        self.session_token
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end

    

    private

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def generate_unique_session_token
        SecureRandom::urlsafe_base64
    end

end
