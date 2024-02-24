class AddPasswordSecurityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reset_password_token, :string, default: SecureRandom.hex(3).upcase!
    add_column :users, :reset_password_sent_at, :datetime, default: Time.now
  end
end
