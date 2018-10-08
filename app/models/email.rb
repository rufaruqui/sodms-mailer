# == Schema Information
#
# Table name: emails
#
#  id                  :integer          not null, primary key
#  creatorid           :string(255)
#  subject             :string(255)
#  body                :text(65535)
#  state               :integer          default(0)
#  permitteddepoid     :integer
#  clientid            :integer
#  from_name           :string(255)
#  from_address        :string(255)
#  reply_address       :string(255)
#  scheduled_on        :datetime
#  sent_on             :datetime
#  recipients          :json
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  attachment          :string(255)
#  attachment_name     :string(255)
#  mail_type           :integer
#  client_name         :string(255)
#  permitted_depo_name :string(255)
#

class Email < ApplicationRecord
end
