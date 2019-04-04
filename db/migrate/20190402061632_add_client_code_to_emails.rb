class AddClientCodeToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :client_code, :string
  end
end
