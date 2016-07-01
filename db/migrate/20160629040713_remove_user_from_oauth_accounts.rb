class RemoveUserFromOauthAccounts < ActiveRecord::Migration
  def change
    remove_reference :oauth_accounts, :user, index: true, foreign_key: true
  end
end
