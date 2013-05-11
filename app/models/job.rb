class Job < ActiveRecord::Base
  acts_as_nested_set
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessible :deadline, :description, :parent_id, :title, :skill_list
  has_many :jobs_workers, :dependent => :destroy, :conditions => "isCreator = 'true'"
  has_many :users, :through => :jobs_workers
  has_many :activities
  
  scope :by_join_date, order("created_at DESC")
end
