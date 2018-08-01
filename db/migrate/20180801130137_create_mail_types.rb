class CreateMailTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :mail_types do |t|
      t.string :name
      t.string :description
      t.datetime :schedule

      t.timestamps
    end
  end
end
