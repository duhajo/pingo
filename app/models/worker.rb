class Worker < ActiveRecord::Base
  attr_accessible :email, :name, :pass
  has_many :job_workers
  has_many :jobs, :through => :job_workers
end
