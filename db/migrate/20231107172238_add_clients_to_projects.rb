class AddClientsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :client, null: true, foreign_key: true
  end
end
