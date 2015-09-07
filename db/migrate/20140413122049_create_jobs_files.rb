class CreateJobsFiles < ActiveRecord::Migration
  def self.up
    create_table :jobs_files do |t|
      t.references :user
      t.references :job
      t.string :file
      t.string :title
      t.text :description
	  
      t.timestamps
    end
    
    add_index :jobs_files, [:job_id, :user_id]
  end
  
  def self.down
    drop_table :jobs_files
  end
end
