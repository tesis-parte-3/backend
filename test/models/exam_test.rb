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
require "test_helper"

class ExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
