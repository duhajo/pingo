class AddJobIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :job_id, :integer
  end
end
