class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  acts_as_votable

  belongs_to :user
  belongs_to :job
  
  attr_accessible :user_id, :comment
  
end
