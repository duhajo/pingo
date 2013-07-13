class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  acts_as_voter
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessor   :login
  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me, :skill_list, :country, :city, :district, :latitude, :longitude, :radius
  has_many :jobs_workers
  has_many :jobs, :through => :jobs_workers
  has_many :activities
		 
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  
  def address
    [district, city, country].compact.join(', ')
  end
  
  def address_changed?
    :country_changed? or :city_changed? or :district_changed?
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
