class Exam < ApplicationRecord
    validates :level, presence: true, inclusion: { in: %w[grado2 grado3 grado5 general] }

    def self.get_quizzes(level = "general")
        specific_level_questions = Exam.where(level: level).sample(35)
        general_questions = Exam.where(level: "general").sample(5)

        quizzes = specific_level_questions + general_questions

        quizzes.shuffle
        
    end
end
