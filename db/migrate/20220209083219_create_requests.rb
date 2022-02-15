class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.text :notes, null: false, default: ""
      t.text :reason_for_rejection, null: false, default: ""
      t.float :shipping_cost, null: false, default: 0.0
      t.float :sales_tax, null: false, default: 0.0
      t.float :import_tax, null: false, default: 0.0
      t.datetime :date_received
      t.datetime :date_approved
      t.datetime :date_ordered
      t.string :order_number
      t.integer :status, null: false, default: 0
      t.references :approved_by, null: true, foreign_key: {to_table: "accounts"}
      t.references :work_breakdown_structure, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :requested_for, null: false, foreign_key: {to_table: "accounts"}
      t.integer :shipping_charges_paid_to
      t.string :vendor, null: false, default: ""

      t.timestamps
    end
  end
end
