class CreateWorkBreakdownStructures < ActiveRecord::Migration[6.1]
  def change
    create_table :work_breakdown_structures do |t|
      t.string :title

      t.timestamps
    end
  end
end
