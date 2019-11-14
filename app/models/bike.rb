class Bike < ApplicationRecord
  belongs_to :user

  has_many :tourist_bikes
  has_many :tourists, through: :tourist_bikes

  mount_uploader :image, ImageUploader

  validates :name, presence: true,
            length: {maximum: 30}
  validates :vehicle_num, presence: true
  validates :security_num, presence: true
  validates :details, length: {maximum: 255}
  validates :image, presence: true

  def self.easy_search_and(str="")

    ## AND 検索
    if str == nil
      return Bike.all
    end
    list = str.gsub("　"," ").split
    if str == nil
      return Bike.all
    end
    list2 = []
    stack = []
    list.each do |txt|
      search_txt = "%" + txt + "%"
      # list2 << search_txt; list2 << search_txt; list2 << search_txt
      list2 << search_txt;
      # stack << " ( name LIKE ? OR teacher LIKE ? OR `when` LIKE ? ) "
      stack << " ( name LIKE ? ) "
    end

    where(stack.join("AND"), *list2)
  end

  def self.search_bike(params)
    restrict = []
    late = []

    key = {
        name: params[:name]
    }

    key.each do |x, y|
      if y != nil
        word_list = y
        stack = []
        word_list.each do |word|
          stack << " " + "`#{x.to_s}`" + " LIKE ?  "
          late << "%" + word + "%"
        end
        stack = " ( " + stack.join("OR") + " ) "
        restrict << stack
      end
    end

    search_str = restrict.join("AND ")

    return where(search_str, *late)
  end
end
