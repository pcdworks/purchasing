class AddActiveToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :active, :boolean, null: false, default: true
  end
end
