class Chat < ApplicationRecord

  belongs_to :user
  belongs_to :room
  varidates :message, presence: true, length: { maximum: 140 }
end
