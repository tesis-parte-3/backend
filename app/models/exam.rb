class Exam < ApplicationRecord
    validates :level, presence: true, inclusion: { in: %w[grado2 grado3 grado5 general] }
end
