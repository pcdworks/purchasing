class AddSeqToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :seq, :integer, default: 0
  end
end
