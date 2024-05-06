class ProjectUniqueId < ActiveRecord::Migration[6.1]
  def up
    add_index :projects, :identifier, unique: true
  end

  def down
    remove_index :projects, :identifier
  end
end
