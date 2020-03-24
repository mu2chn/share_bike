# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  AdminUser.create!(email: '4181hiro@gmail.com', password: 'aaaaaa')
  User.create!(name:"face", email: "face@st.kyoto-u.ac.jp", password: "aaaaaa", authenticated: true, temp_terms: true )
  Tourist.create!(name: "face", email:"face93631@eay.jp", password: "aaaaaa", authenticated: true, temp_terms: true)
end

Parking.create!(name: "京大三号館東", lat: 35.027898, lng: 135.781254)