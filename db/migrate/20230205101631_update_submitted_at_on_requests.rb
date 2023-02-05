class UpdateSubmittedAtOnRequests < ActiveRecord::Migration[6.1]
  def self.up
    Request.update_all("submitted_at=created_at")
  end

  def self.down
  end
end
