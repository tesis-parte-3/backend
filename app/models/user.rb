class User < ApplicationRecord
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :dni, presence: true, uniqueness: true
    validates :name, presence: true
    validates :password,
              length: { minimum:8 },
              if: -> { new_record? || !password.nil? }
end
