class CreateJobWorkers < ActiveRecord::Migration
  def change
    create_table :job_workers do |t|
      t.integer :user_id
      t.integer :job_id
      t.boolean :iscreator

      t.timestamps
    end
  end
end
