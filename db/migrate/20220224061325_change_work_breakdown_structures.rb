class ChangeWorkBreakdownStructures < ActiveRecord::Migration[6.1]
  def up
    remove_column :requests, :work_breakdown_structure_id
    add_column :requests, :work_breakdown_structure, :string
  end

  def down
    remove_column :requests, :work_breakdown_structure
    add_column :requests, :work_breakdown_structure_id, :integer, references: :work_breakdown_structure
  end
end
