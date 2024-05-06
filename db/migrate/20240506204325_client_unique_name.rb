class ClientUniqueName < ActiveRecord::Migration[6.1]
  def up
    add_index :clients, :title, unique: true
  end

  def down
    remove_index :clients, :title
  end
end
