class OauthAccount < ActiveRecord::Base
  belongs_to :regular_user
end
