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
    after_create :welcome_email

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
        self.approved_exams = approved_exams + 1
        if self.save
            return { message: "ok", user: User.find(self.id) }
        else
            return { message: "error", user: User.find(self.id) }
        end
    end

    def reprove_exam
        self.reproved_exams = reproved_exams + 1
        if self.save
            return { message: "ok", user: User.find(self.id) }
        else
            return { message: "error", user: User.find(self.id) }
        end
    end

    def token_is_valid?(token = '')
        token == self.reset_password_token
    end

    
    def welcome_email
        $resend.api_key = ENV["email_token"]
        
        params = {
            "from": "Acme <onboarding@resend.dev>",
            "to": [self.email],
            "subject": "Bienvenido a QuizDrive!",
            "html": "<strong><center>Bienvenido a QuizDrive!</center></strong>"
        }
        
        sent = $resend::Emails.send(params)
        puts sent
    end
    
    private
    
    def set_stats
        self.approved_exams = 0
        self.reproved_exams = 0
    end
end
