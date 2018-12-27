class AddCcToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :cc, :json
  end
end
