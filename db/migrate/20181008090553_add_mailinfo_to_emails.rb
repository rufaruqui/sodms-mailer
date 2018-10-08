class AddMailinfoToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :client_name, :string
    add_column :emails, :permitted_depo_name, :string
  end
end
