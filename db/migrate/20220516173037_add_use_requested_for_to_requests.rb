class AddUseRequestedForToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :use_requested_for, :boolean, default: false
  end
end
