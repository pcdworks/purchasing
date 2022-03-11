class Item < ApplicationRecord
  belongs_to :request

  validates :vendor_reference, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :quantity, presence: true, allow_blank: false
  validates :price, presence: true, allow_blank: false
  belongs_to :received_by, class_name: "Account", optional: true

  before_save :clean_up


  def total
    self.price.to_f * self.quantity.to_i
  end

  def clean_up
    self.description = self.description.strip unless self.description.nil?
    self.vendor_reference = self.vendor_reference.strip unless self.vendor_reference.nil?
    self.link = self.link.strip unless self.link.nil?
    unless self.link.start_with?('https://') || self.link.start_with?('https://')
      self.link = 'https://' + self.link.to_s
    end
  end

  def link?
    self.link && self.link != ''
  end

  def received?
    !self.received_by_id.nil?
  end
end
