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
    before_save :normalize

    validates :email, presence: true, uniqueness: true
    validates :dni, presence: true, uniqueness: true, format: {
        with: /\A[VEJPG]-\d{1,11}\z/,
        message: 'Debe incluir (V J E G P) '
      }
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

    def successfully_reset_password
        self.reset_password_token = SecureRandom.hex(3).upcase!
        self.reset_password_sent_at = Time.now.utc
        self.save

        $resend.api_key = ENV["email_token"]

        params = {
            "from": "#{ENV["company"]} <#{ENV["company_email"]}>",
            "to": [self.email],
            "subject": "Contraseña restablecida",
            "html": "
                <div style='text-align: center; background-color: #f2f2f2; padding: 50px;'>
                    <span style='font-size: 50px;'>🎊</span>
                    <h1 style='font-size: 30px; color: #333;'>Contraseña restablecida</h1>
                    <p style='font-size: 20px; color: #666;'>Tu contraseña ha sido restablecida con éxito</p>
                </div>
            "
        }

        sent = $resend::Emails.send(params)
        puts sent
    end

    def send_password_reset
        $resend.api_key = ENV["email_token"]

        params = {
            "from": "#{ENV["company"]} <#{ENV["company_email"]}>",
            "to": [self.email],
            "subject": "Recuperación de contraseña",
            "html": "
                <div style='text-align: center; background-color: #f2f2f2; padding: 50px;'>
                    <span style='font-size: 50px;'>🔑</span>
                    <h1 style='font-size: 30px; color: #333;'>Recuperación de contraseña</h1>
                    <p style='font-size: 20px; color: #666;'>Hemos recibido una solicitud para restablecer tu contraseña</p>
                    <p style='font-size: 20px; color: #fff; padding: 10px; background-color: #008DDA; margin-top: 20px; border-radius: 5px; letter-spacing: 6px'>#{self.reset_password_token}</p>
                </div>
            "
        }

        sent = $resend::Emails.send(params)
        puts sent
    end
    
    def welcome_email
        $resend.api_key = ENV["email_token"]
        
        params = {
            "from": "#{ENV["company"]} <#{ENV["company_email"]}>",
            "to": [self.email],
            "subject": "Bienvenido a QuizDrive!",
            "html": "
                <div style='text-align: center; background-color: #f2f2f2; padding: 50px;'>
                    <span style='font-size: 50px;'>👋</span>
                    <h1 style='font-size: 30px; color: #333;'>Te damos la bienvenida a QuizDrive!</h1>
                    <p style='font-size: 20px; color: #666;'>Estamos muy contentos de que estés aquí</p>
                    <a style='font-size: 20px; color: #fff; padding: 10px; background-color: #008DDA; margin-top: 20px; border-radius: 5px' href='https://ismoxpage.online/login'>Comienza a aprender</a>
                </div>
            "
        }
        
        sent = $resend::Emails.send(params)
        puts sent
    end
    
    private

    def normalize
        self.email = self.email.downcase
    end

    def set_stats
        self.approved_exams = 0
        self.reproved_exams = 0
    end
end
