class CreateSchedulers < ActiveRecord::Migration[5.0]
  def change
    create_table :schedulers do |t|
      t.string :task_name
      t.string :execution_time

      t.timestamps
    end
  end
end
