class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.string :level
      t.string :question
      t.jsonb :answers
      t.string :correct_answer

      t.timestamps
    end
  end
end
