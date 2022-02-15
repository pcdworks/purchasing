class RenameRequestedBy < ActiveRecord::Migration[6.1]
  def self.up
    rename_column :requests, :requested_by_id, :requested_for_id
  end

  def self.down
    rename_column :requests, :requested_for_id, :requested_by_id
  end
end
