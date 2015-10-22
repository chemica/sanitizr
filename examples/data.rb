require "rubygems"
require "sanitizr"


db = Sanitizr::Database.new

db.table :cms_users do
  field :email, unique: true
  field :encrypted_password, type: :password
  field :name
end

db.table :users do
  field :email, uniq: true
  field :encrypted_password, type: :password
  field :reset_password_token, type: :password_token
  field :first_name
  field :last_name
  field :display_name
  field :nectar_card_number,type: :number
  field :confirmation_token,type: :number
  field :unconfirmed_email,type: :email
  field :unlock_token,type: :number
end
