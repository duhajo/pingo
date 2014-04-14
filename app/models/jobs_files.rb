class JobsFiles < ActiveRecord::Base
  attr_accessible :user_id, :job_id, :file, :file_cache
  belongs_to :user
  belongs_to :job
  
  mount_uploader :file, FileUploader
end
