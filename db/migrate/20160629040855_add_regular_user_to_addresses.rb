class AddRegularUserToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :regular_user, index: true, foreign_key: true
  end
end
