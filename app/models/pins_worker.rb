class PinsWorker < ActiveRecord::Base
  attr_accessible :user_id, :pin_id, :is_creator
  belongs_to :user
  belongs_to :pin
end
