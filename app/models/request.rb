class Request < ApplicationRecord
  belongs_to :approved_by, class_name: "Account", optional: true
  belongs_to :project
  belongs_to :payment_method
  belongs_to :account
  belongs_to :requested_for, class_name: "Account"
  belongs_to :received_by, class_name: "Account", optional: true
  before_save :clean_up

  has_many :items, -> { order(created_at: :desc) }, inverse_of: :request, dependent: :destroy
  has_many_attached :attachment

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  validates :vendor, presence: true, allow_blank: false
  validates :identifier, uniqueness: true

  def submitted?
    !self.submitted_at.nil?
  end

  def on_hold?
    !self.on_hold_until.nil?
  end

  def approved?
    !self.date_approved.nil?
  end

  def ordered?
    !self.date_ordered.nil?
  end

  def received
    r = self.items.where.not(received_at: nil).count, self.items.count
    return {
             all: (r[0] == r[1]) && (r[0] != 0),
             some: (r[0] != r[1]) && (r[0] != 0),
           }
  end

  def received_at
    self.items.where.not(received_at: nil).order(received_at: :desc).first.received_at
  end

  def returned_at
    self.items.where.not(returned_at: nil).order(returned_at: :desc).first.returned_at
  end

  def returned
    r = self.items.count { |item| item.returned? }, self.items.count
    return {
             all: r[0] == r[1] && r[0] != 0,
             some: r[0] != r[1] && r[0] != 0,
           }
  end

  def to_param
    self.identifier
  end

  def to_s
    if self.identifier.to_s  != ''
      self.identifier.upcase
    else
      self.created_at.strftime("%Y%m%d") + self.account.initials + (self.seq.to_i + 64).chr.to_s
    end
  end

  def subtotal
    self.items.sum("price * quantity") - self.items.sum("refund")
  end

  def total
    self.subtotal + self.shipping_cost.to_f + self.import_tax.to_f + self.sales_tax.to_f + self.surcharge.to_f
  end

  def clean_up

    # make sure there is a created date so we can generate the identifier
    self.created_at ||= Date.today

    # figure out the sequence number
    if !self.seq ||
        self.seq == 0 ||
        (self.use_requested_for_changed? && self.requested_for_id_changed?) ||
        self.created_at_changed?
      if self.use_requested_for
        taccount_id = self.requested_for_id
      else
        taccount_id = self.account_id
      end
      id = self.identifier
      ran = self.created_at.beginning_of_day..self.created_at.end_of_day
      self.seq = Request.where.not(identifier: id)
                        .where(account_id: taccount_id, created_at: ran).count +
                 Request.where.not(account_id: taccount_id, identifier: id)
                        .where(requested_for_id: taccount_id, use_requested_for: true, created_at: ran).count + 1
    end

    # create identifier
    if self.use_requested_for
      ident = (self.created_at.strftime("%Y%m%d") + self.requested_for.initials + (self.seq.to_i + 64).chr.to_s).downcase
    else
      ident = (self.created_at.strftime("%Y%m%d") + self.account.initials + (self.seq.to_i + 64).chr.to_s).downcase
    end

    if self.identifier.nil? || self.identifier == "" || self.identifier != ident
      if Request.exists?(identifier: ident)
        ident[-1] = (ident[-1].ord + 1).chr
      end
      self.identifier = ident
      self.seq = ident[-1].ord - 96
    end

    # set the date for approval if approved
    if self.approved_by && !self.date_approved
      self.date_approved = DateTime.now
    end

    # clean up fields
    self.vendor = self.vendor.strip unless self.vendor.nil?
    self.order_number = self.order_number.strip unless self.order_number.nil?
    self.notes = self.notes.strip unless self.notes.nil?
    self.reason_for_rejection = self.reason_for_rejection.strip unless self.reason_for_rejection.nil?
    self.work_breakdown_structure = self.work_breakdown_structure.strip unless self.work_breakdown_structure.nil?
    self.shipping_cost = self.shipping_cost.to_f
    self.import_tax = self.import_tax.to_f
    self.sales_tax = self.sales_tax.to_f
    self.surcharge = self.surcharge.to_f

    # update completion
    completed = self.items.where.not(received_at: nil).or(self.items.where.not(returned_at: nil)).count
    total = self.items.count
    self.completion = [
      self.date_ordered.nil? ? 0 : 8,
      completed != total ? 0 : 4,
      self.date_approved.nil? ? 0 : 2,
      self.submitted_at.nil? ? 0 : 1,
    ].sum()
  end

  def received?
    self.items.where.not(received_at: nil).count == self.items.count
  end

  def returned?
    self.items.where.not(returned_at: nil).count == self.items.count
  end

  def received_or_returned?
    self.items.where.not(received_at: nil).or(self.items.where.not(returned_at: nil)).count == self.items.count
  end

  def column_class
    warning_weeks_ago = DateTime.now - 3.weeks
    danger_weeks_ago = DateTime.now - 5.weeks
    not_finished = self.completion < 15
    if not_finished
      # if the order has not been received in the last four weeks and it has been orderd then set to danger
      if !self.received_or_returned? && !self.date_ordered.nil? && self.date_ordered < danger_weeks_ago
        return "table-danger"
        # if the order has been created and not finished in the last four weeks then set to danger
      elsif self.updated_at < danger_weeks_ago
        return "table-danger"
        # if the order has been received and not finished in the last two weeks then set to warning
      elsif self.updated_at < warning_weeks_ago
        return "table-warning"
      else
        return ""
      end
    else
      return ""
    end # not finished
  end
end
