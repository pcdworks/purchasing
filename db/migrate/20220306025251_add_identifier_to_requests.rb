class AddIdentifierToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :identifier, :string
  end
end
