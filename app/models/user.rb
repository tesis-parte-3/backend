# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  approved_exams         :integer
#  avatar                 :string
#  dni                    :string
#  email                  :string
#  name                   :string
#  password_digest        :string
#  reproved_exams         :integer
#  reset_password_sent_at :datetime         default(Sun, 17 Mar 2024 01:53:18.173398000 UTC +00:00)
#  reset_password_token   :string           default("F5EE22")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
    has_secure_password
    mount_uploader :avatar, AvatarUploader

    after_create :set_stats

    validates :email, presence: true, uniqueness: true
    validates :dni, presence: true, uniqueness: true
    validates :name, presence: true
    # validates :password,
    #           length: { minimum: 6 }

    def generate_password_token
        self.reset_password_token = SecureRandom.hex(3).upcase!
        self.reset_password_sent_at = Time.now.utc
        save!
    end         

    def approve_exam
        self.approved_exams += 1
    end

    def reprove_exam
        self.reproved_exams += 1
    end

    def token_is_valid?(token = '')
        token == self.reset_password_token
    end

    private

    def set_stats
        self.approved_exams = 0
        self.reproved_exams = 0
    end
end
