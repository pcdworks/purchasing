class AddOnHoldUntilToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :on_hold_until, :datetime
  end
end
