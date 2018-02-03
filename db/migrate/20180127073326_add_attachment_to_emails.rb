class AddAttachmentToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :attachment, :string
  end
end
