class MakeIdentifierUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :requests, :identifier, unique: true
  end
end
