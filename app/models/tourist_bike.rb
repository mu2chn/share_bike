class TouristBike < ApplicationRecord
  belongs_to :bike
  belongs_to :tourist, optional: true
end
