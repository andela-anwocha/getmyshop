class AddRegularUserToOauthAccounts < ActiveRecord::Migration
  def change
    add_reference :oauth_accounts, :regular_user, index: true, foreign_key: true
  end
end
