class CreateJobsWorkers < ActiveRecord::Migration
  def self.up
    create_table :jobs_workers, :id => false do |t|
      t.references :user
      t.references :job
      t.boolean :isCreator
      t.timestamps
    end
    
    add_index :jobs_workers, [:job_id, :user_id]
  end
  
  def self.down
    drop_table :jobs_workers
  end
end
