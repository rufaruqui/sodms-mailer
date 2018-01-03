class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t| 
      t.string :creatorid
      t.string :subject
      t.text :body
      t.integer :state, default: 0
      t.integer :permitteddepoid
      t.integer :clientid
      t.string :from_name
      t.string :from_address
      t.string :reply_address
      t.datetime :scheduled_on
      t.datetime :sent_on
      t.json :recipients
      t.timestamps 
    end
  end
end
