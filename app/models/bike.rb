class Bike < ApplicationRecord
  belongs_to :user

  has_many :tourist_bikes
  has_many :tourists, through: :tourist_bikes

  mount_uploader :image, ImageUploader
end
