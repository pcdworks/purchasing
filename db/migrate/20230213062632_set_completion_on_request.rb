class SetCompletionOnRequest < ActiveRecord::Migration[6.1]
  def self.up
    Request.all.each do |r|
      r.save!
    end
  end

  def self.down
  end
end
