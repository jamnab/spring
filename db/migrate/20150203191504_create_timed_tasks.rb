class CreateTimedTasks < ActiveRecord::Migration
  def change
    create_table :timed_tasks do |t|
      t.integer :interval
      t.string :measure_of_time

      t.timestamps null: false
    end
  end
end
