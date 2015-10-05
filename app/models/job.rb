class Job < ActiveRecord::Base
  self.inheritance_column = nil
  acts_as_commentable
  acts_as_taggable
  acts_as_taggable_on :skills
  acts_as_nested_set
  acts_as_votable
  attr_accessible :deadline, :description, :parent_id, :title, :skill_list, :country, :city, :street, :type, :picture, :picture_cache
  has_many :jobs_workers, dependent: :delete_all
  has_many :users, :through => :jobs_workers

  include PublicActivity::Common

  mount_uploader :picture, PictureUploader

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  def gmaps4rails_address
    "#{self.street}, #{self.city}, #{self.country}"
  end

  scope :by_join_date, order("created_at DESC")

  def address
    @address = ""
    unless street.nil? && city.nil? && country.nil?
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
  
  def self.is_creator_of_job(job, current_user)
    if JobsWorker.where(:job_id => job.id).where('jobs_workers.is_creator' => true).where(:user_id => current_user.id).to_a.empty?
      return false
    else
      return true
    end
  end
  
  def self.get_user_role(job, current_user)
    if current_user
      if job.users.find_by_id(current_user.id)
        if is_creator_of_job(job, current_user)
          return 3 #manager
        else
          return 2 #worker
        end
      else
        return 1 #keine role
      end
    else
      return 0
    end
  end
end
