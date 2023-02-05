class AddSubmittedAtToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :submitted_at, :datetime
  end
end
