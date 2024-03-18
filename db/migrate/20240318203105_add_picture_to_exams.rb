class AddPictureToExams < ActiveRecord::Migration[7.0]
  def change
    add_column :exams, :picture, :string
  end
end
