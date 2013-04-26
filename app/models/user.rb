class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :name, :email, :password, :password_confirmation, :skill_list

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
               :length => { :maximum => 50 }
  validates :email, :presence => true,
                :format => { :with => email_regex },
                :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                   :confirmation => true,
                   :length => { :within => 6..40 }
  validates_presence_of :password, :on => :create
  has_many :job_workers
  has_many :jobs, :through => :job_workers
  
  acts_as_taggable
  acts_as_taggable_on :skills
end
