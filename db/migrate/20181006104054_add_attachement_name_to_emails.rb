class AddAttachementNameToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :attachment_name, :string
  end
end
