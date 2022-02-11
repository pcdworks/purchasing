class Item < ApplicationRecord
  belongs_to :request

  def total
    self.price.to_f * self.quantity.to_i
  end
end
