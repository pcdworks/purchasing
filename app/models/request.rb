class Request < ApplicationRecord
  belongs_to :approved_by, class_name: "Account", optional: true
  belongs_to :project
  belongs_to :payment_method
  belongs_to :account
  belongs_to :requested_for, class_name: "Account"
  before_save :clean_up

  has_many :items, inverse_of: :request, dependent: :destroy
  has_many_attached :attachment

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  validates :vendor, presence: true, allow_blank: false

  def to_s
    'PR' + self.created_at.strftime("%Y%m%d") + self.account.initials + (self.seq.to_i+64).chr.to_s + '-' + self.vendor.gsub(' ', '_') 
  end

  def subtotal
    self.items.sum(&:total)
  end

  def total
    self.subtotal + self.shipping_cost.to_f + self.import_tax.to_f + self.sales_tax.to_f + self.surcharge.to_f
  end

  def clean_up
    # set the date for approval if approved
    if self.approved_by && !self.date_approved
      self.date_approved = DateTime.now
    end

    # auto update the status to approved for the approver
    if self.status == 1 && self.approved_by
      self.status = 2
    end

    # Don't allow unapproval
    if self.date_approved && self.status < 2
      self.status = 2
    end

    # Don't allow by passing approval
    if !self.date_approved && self.status > 1
      self.status = 1
    end

    self.vendor = self.vendor.strip unless self.vendor.nil?
    self.order_number = self.order_number.strip unless self.order_number.nil?
    self.notes = self.notes.strip unless self.notes.nil?
    self.reason_for_rejection = self.reason_for_rejection.strip unless self.reason_for_rejection.nil?
    self.work_breakdown_structure = self.work_breakdown_structure.strip unless self.work_breakdown_structure.nil?

    if !self.seq || self.seq == 0
      self.seq = Request.where('account_id = ? and created_at > ?', self.account_id, DateTime.now - 12.hours).count + 1
    end
  end

end
