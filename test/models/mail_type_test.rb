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

require 'test_helper'

class MailTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
