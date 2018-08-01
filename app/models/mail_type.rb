# == Schema Information
#
# Table name: mail_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  schedule    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MailType < ApplicationRecord
end
