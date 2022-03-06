class AddReceivedByToRequests < ActiveRecord::Migration[6.1]
  def change
    add_reference :requests, :received_by, null: true, foreign_key: {to_table: "accounts"}
  end
end
