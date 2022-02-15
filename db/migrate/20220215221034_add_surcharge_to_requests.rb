class AddSurchargeToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :surcharge, :float, default: 0.0
  end
end
