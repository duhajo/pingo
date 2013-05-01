class Job < ActiveRecord::Base
  acts_as_nested_set
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessible :deadline, :description, :lft, :parent_id, :rgt, :title, :skill_list
  has_many :jobs_workers, :dependent => :destroy, :conditions => "isCreator = 'true'"
  has_many :users, :through => :jobs_workers
end
