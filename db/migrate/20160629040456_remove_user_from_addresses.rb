class RemoveUserFromAddresses < ActiveRecord::Migration
  def change
    remove_reference :addresses, :user, index: true, foreign_key: true
  end
end
