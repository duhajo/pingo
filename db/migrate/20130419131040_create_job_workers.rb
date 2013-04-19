class CreateJobWorkers < ActiveRecord::Migration
  def change
    create_table :job_workers do |t|
      t.integer :job_id
      t.integer :worker_id
      t.boolean :iscreator

      t.timestamps
    end
  end
end
