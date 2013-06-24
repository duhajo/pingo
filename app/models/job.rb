class Job < ActiveRecord::Base
  acts_as_nested_set
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessible :deadline, :description, :parent_id, :title, :skill_list, :country, :city, :street
  has_many :jobs_workers, :dependent => :destroy
  has_many :users, :through => :jobs_workers
  has_many :activities
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  
  acts_as_gmappable

  def gmaps4rails_address
    "#{self.street}, #{self.city}, #{self.country}" 
  end
  
  scope :by_join_date, order("created_at DESC")

  def address
    [street, city, country].compact.join(', ')
  end
  
  def address_changed?
    :country_changed? or :city_changed? or :street_changed?
  end
end
