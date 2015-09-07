class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  attr_accessible :body

  validates_presence_of :body, :conversation_id, :user_id
end
