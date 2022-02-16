class AddApproverToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :approver, :boolean, default: false
  end
end
