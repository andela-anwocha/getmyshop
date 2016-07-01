class AddRegularUserToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :regular_user, index: true, foreign_key: true
  end
end
