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
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :dni, :approved_exams, :reproved_exams, :users_quantity, :created_at, :updated_at

  def users_quantity
    User.count
  end
end
