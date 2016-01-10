class PinTag < ActiveRecord::Base
  attr_accessible :pin_id, :tag_id
  belongs_to :pin
  belongs_to :tag
end
