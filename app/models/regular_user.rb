class RegularUser < User
  has_many :oauth_accounts
  has_many :orders
  has_many :addresses, dependent: :destroy
end
