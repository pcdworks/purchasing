class AddActiveToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :active, :boolean, default: true, null: false
  end
end
