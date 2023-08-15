class AddReturnedByReasonForRejectionToItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :items, :returned_by, null: true, foreign_key: {to_table: "accounts"}
    add_column :items, :reason_for_rejection, :string, default: ""
  end
end
