class AddCompletionToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :completion, :integer, default: 0, null: false
  end
end
