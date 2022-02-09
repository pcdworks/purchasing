class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :description
      t.string :vendor_reference
      t.integer :quantity
      t.float :price
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
