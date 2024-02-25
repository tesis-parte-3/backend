class User < ApplicationRecord
    has_secure_password

    before_update :validates_change_password

    validates :email, presence: true, uniqueness: true
    validates :dni, presence: true, uniqueness: true
    validates :name, presence: true
    validates :password,
              length: { minimum:8 },
              if: -> { !password.nil? }

    def generate_password_token
        self.reset_password_token = SecureRandom.hex(3).upcase!
        self.reset_password_sent_at = Time.now.utc
        save!
    end         

    def token_is_valid?(token = '')
        token == self.reset_password_token
    end

    def validates_change_password
        @password = self.password

        self.password = @password
        save
    end
end
