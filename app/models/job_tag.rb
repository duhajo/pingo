class JobTag < ActiveRecord::Base
  attr_accessible :job_id, :tag_id
  belongs_to :job
  belongs_to :tag
end
