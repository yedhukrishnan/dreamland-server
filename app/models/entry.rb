class Entry < ApplicationRecord
  belongs_to :user
  validates_presence_of :uuid, :text, :user_id, :date, :address, :latitude, :longitude
  validates_uniqueness_of :uuid
end
