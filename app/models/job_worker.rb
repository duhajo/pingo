class JobWorker < ActiveRecord::Base
  attr_accessible :job_id, :worker_id, :iscreator
  belongs_to :user
  belongs_to :job
end
