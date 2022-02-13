class Item < ApplicationRecord
  belongs_to :request

  validates :vendor_reference, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :quantity, presence: true, allow_blank: false
  validates :price, presence: true, allow_blank: false


  def total
    self.price.to_f * self.quantity.to_i
  end
end
