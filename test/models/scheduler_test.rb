# == Schema Information
#
# Table name: schedulers
#
#  id             :integer          not null, primary key
#  task_name      :string(255)
#  execution_time :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
