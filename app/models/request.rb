class Request < ApplicationRecord
  belongs_to :approved_by, class_name: "Account", optional: true
  belongs_to :work_breakdown_structure
  belongs_to :project
  belongs_to :payment_method
  belongs_to :account
  belongs_to :requested_by, class_name: "Account"
  before_save :clean_up

  has_many :items, inverse_of: :request, dependent: :destroy

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  validates :vendor, presence: true, allow_blank: false

  def to_s
    'PR' + self.created_at.strftime("%Y%m%d") + self.account.initials + '-' + self.vendor.gsub(' ', '_') 
  end

  def subtotal
    self.items.sum(&:total)
  end

  def total
    self.subtotal + self.shipping_cost.to_f + self.import_tax.to_f + self.sales_tax.to_f
  end

  def clean_up
    if self.approved_by && !self.date_approved
      self.date_approved = DateTime.now
    end
    self.vendor = self.vendor.strip unless self.vendor.nil?
    self.order_number = self.order_number.strip unless self.order_number.nil?
    self.notes = self.notes.strip unless self.notes.nil?
    self.reason_for_rejection = self.reason_for_rejection.strip unless self.reason_for_rejection.nil?
  end
end
