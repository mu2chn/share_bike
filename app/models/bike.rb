class Bike < ApplicationRecord
  belongs_to :user

  has_many :tourist_bikes
end
