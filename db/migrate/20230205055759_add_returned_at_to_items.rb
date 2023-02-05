class AddReturnedAtToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :returned_at, :datetime
  end
end
