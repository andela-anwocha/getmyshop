class Address < ActiveRecord::Base
  belongs_to :regular_user
  has_many :orders

  validates :name, :address, :phone, :state, :city, presence: true
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  }
end
