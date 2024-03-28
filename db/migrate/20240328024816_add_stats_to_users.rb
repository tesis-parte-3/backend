class AddStatsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :approved_exams, :integer
    add_column :users, :reproved_exams, :integer
  end
end
