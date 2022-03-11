class AddReceivedByReceivedAtToItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :items, :received_by, null: true, foreign_key: {to_table: "accounts"}
    add_column :items, :received_at, :datetime
    add_column :items, :link, :string, null: false, default: ""
  end
end
