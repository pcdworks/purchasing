class Item < ApplicationRecord
  belongs_to :request

  validates :vendor_reference, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :quantity, presence: true, allow_blank: false
  validates :price, presence: true, allow_blank: false

  before_save :clean_up


  def total
    self.price.to_f * self.quantity.to_i
  end

  def clean_up
    self.description = self.description.strip unless self.description.nil?
    self.vendor_reference = self.vendor_reference.strip unless self.vendor_reference.nil?
  end
end
