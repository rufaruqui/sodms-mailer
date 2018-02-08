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

class Scheduler < ApplicationRecord
end
