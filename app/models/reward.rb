class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :tourist_bike

  validates :tourist_bike_id, uniqueness: true
end