class Job < ActiveRecord::Base
  include PublicActivity::Common
  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  acts_as_commentable
  acts_as_nested_set
  acts_as_votable
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessible :deadline, :description, :parent_id, :title, :skill_list, :country, :city, :street
  has_many :jobs_workers, :dependent => :destroy
  has_many :users, :through => :jobs_workers

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  
  acts_as_gmappable validation: false

  def gmaps4rails_address
    "#{self.street}, #{self.city}, #{self.country}" 
  end
  
  scope :by_join_date, order("created_at DESC")

  def address
    @address = ""
    unless street.empty? 
      @address << street
    end
    unless city.empty? 
      if @address != ""
        @address << ", "
      end
      @address << city
    end
    unless country.empty?
      if @address != ""
        @address << ", "
      end
      @address << country
    end
    return @address
  end
  
  def address_changed?
    :country_changed? or :city_changed? or :street_changed?
  end
end
