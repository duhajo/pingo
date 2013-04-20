class Job < ActiveRecord::Base
  acts_as_nested_set
  attr_accessible :deadline, :description, :lft, :parent_id, :rgt, :title
  has_many :job_workers
  has_many :workers, :through => :job_workers
end
