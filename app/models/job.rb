class Job < ActiveRecord::Base
  self.inheritance_column = nil
  include PublicActivity::Common
  acts_as_commentable
  acts_as_nested_set
  acts_as_votable
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessible :deadline, :description, :parent_id, :title, :skill_list, :country, :city, :street, :type, :picture, :picture_cache
  has_many :jobs_workers, dependent: :delete_all
  has_many :users, :through => :jobs_workers
  
  mount_uploader :picture, PictureUploader

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

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

  def self.search(search)
    if search
      find(:all, :conditions => ['title LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
