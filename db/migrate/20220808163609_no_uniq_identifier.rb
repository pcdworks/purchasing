class NoUniqIdentifier < ActiveRecord::Migration[6.1]
  def up
    remove_index :requests, :identifier
  end

  def down
    add_index :requests, :identifier, unique: true
  end
end
