class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :job_tags
  has_many :jobs, :through => :job_tags
end
