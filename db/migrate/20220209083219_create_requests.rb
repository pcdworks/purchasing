class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.text :notes
      t.text :reason_for_rejection
      t.float :shipping_cost
      t.float :sales_tax
      t.float :import_tax
      t.datetime :date_received
      t.datetime :date_shipped
      t.datetime :date_ordered
      t.string :order_number
      t.integer :status
      t.references :approved_by, null: true, foreign_key: {to_table: "accounts"}
      t.references :work_breakdown_structure, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :requested_by, null: false, foreign_key: {to_table: "accounts"}
      t.integer :shipping_charges_paid_to
      t.string :vendor

      t.timestamps
    end
  end
end
