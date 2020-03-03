class UserReview < ApplicationRecord
  validates :tourist_bike_id, uniqueness: true
end
