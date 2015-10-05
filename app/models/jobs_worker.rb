class JobsWorker < ActiveRecord::Base
  attr_accessible :user_id, :job_id, :is_creator
  belongs_to :user
  belongs_to :job
end
