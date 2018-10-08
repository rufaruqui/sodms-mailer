class AddMailDeliverySettingIdToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :mail_delivery_setting_id, :integer
  end
end
