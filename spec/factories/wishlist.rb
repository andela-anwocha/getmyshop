FactoryGirl.define do
  factory :wishlist do
    regular_user
    product factory: :product
  end
end
