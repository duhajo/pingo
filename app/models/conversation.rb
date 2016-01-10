class Conversation < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'
  belongs_to :pin, :foreign_key => :pin_id, class_name: 'pin'

  has_many :messages, dependent: :destroy

  attr_accessible :sender_id, :recipient_id, :pin_id

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  scope :involving, ->(user) do
    where("conversations.sender_id =? OR conversations.recipient_id =?",
          user.id,user.id)
  end

  scope :pin_involving, ->(user,pin_id) do
    where("(conversations.sender_id =? OR conversations.recipient_id =?) AND conversations.pin_id = ?",
          user.id,user.id,pin_id)
  end

  scope :between, ->(sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?) AND (conversations.pin_id = '')",
          sender_id,recipient_id,recipient_id,sender_id)
  end

  scope :between_pin, ->(sender_id,recipient_id,pin_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?) AND (conversations.pin_id = ?)",
          sender_id,recipient_id,recipient_id,sender_id,pin_id)
  end
end