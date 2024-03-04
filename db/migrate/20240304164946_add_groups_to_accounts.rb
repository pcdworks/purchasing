class AddGroupsToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :groups, :jsonb, default: [], null: false
  end
end
