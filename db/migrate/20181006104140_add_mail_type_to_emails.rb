class AddMailTypeToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :mail_type, :integer
  end
end
