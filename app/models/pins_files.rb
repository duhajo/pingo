class PinsFiles < ActiveRecord::Base
  attr_accessible :user_id, :pin_id, :file, :file_cache
  belongs_to :user
  belongs_to :pin

  mount_uploader :file, FileUploader
end
