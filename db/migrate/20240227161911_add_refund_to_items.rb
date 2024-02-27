class AddRefundToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :refund, :float, dafault: 0.0
  end
end
