# == Schema Information
#
# Table name: exams
#
#  id             :bigint           not null, primary key
#  answers        :jsonb
#  correct_answer :string
#  level          :string
#  picture        :string
#  question       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Exam < ApplicationRecord
    mount_uploader :picture, PictureUploader

    validates :level, presence: true, inclusion: { in: %w[grado2 grado3 grado5 general] }

    def self.get_quizzes(level = "general")
        specific_level_questions = Exam.where(level: level).sample(35)
        general_questions = Exam.where(level: "general").sample(5)

        quizzes = specific_level_questions + general_questions

        quizzes.shuffle
        
    end
end
