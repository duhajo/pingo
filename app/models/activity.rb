class Activity < ActiveRecord::Base
  acts_as_nested_set
  
  attr_accessible :content, :type, :parent_id
  
  belongs_to :user
  belongs_to :job
end
