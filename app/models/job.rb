class Job < ActiveRecord::Base
  attr_accessible :deadline, :description, :job_id, :title
  has_many :job_workers
  has_many :workers, :through => :job_workers
end
