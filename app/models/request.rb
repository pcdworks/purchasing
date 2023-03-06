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

  # make sure the identifier follows the pattern
  validate do |request|
    po_good = request.identifier.to_s == '' ||
    (request.identifier.count('a-zA-Z') == 3 &&
     request.identifier.count('0123456789') >= 6)
    request.errors.add(:base, "PO identifier must follow the pattern") unless po_good
  end

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
      some: (r[0] != r[1]) && (r[0] != 0)
    }
  end

  def returned
    r = self.items.count { |item| item.returned? }, self.items.count
    return {
      all: r[0] == r[1] && r[0] != 0, 
      some: r[0] != r[1] && r[0] != 0
    }
  end

  def to_param
    self.identifier
  end


  def to_s
    if self.identifier
      self.identifier.titleize
    else
      self.created_at.strftime("%Y%m%d") + self.account.initials + (self.seq.to_i+64).chr.to_s
    end + '-' + self.vendor.gsub(' ', '_')
  end

  def subtotal
    self.items.sum('price * quantity')
  end

  def total
    self.subtotal + self.shipping_cost.to_f + self.import_tax.to_f + self.sales_tax.to_f + self.surcharge.to_f
  end

  def clean_up

    # if received by someone then set the date if they forgot to
    if !self.date_received && self.received_by
      self.date_received = DateTime.now
    end

    # make sure there is a created date so we can generate the identifier
    self.created_at ||= Date.today

    # figure out the sequence number
    if !self.seq || self.seq == 0 || self.use_requested_for_changed? || self.requested_for_id_changed? || self.created_at_changed?
      if self.use_requested_for
        taccount_id = self.requested_for_id
      else
        taccount_id = self.account_id
      end
        self.seq = Request.where('account_id = ? and created_at = ?',
                                taccount_id, Date.today).count +
                   Request.where('account_id != ? and requested_for_id = ? and use_requested_for = true and created_at = ?',
                                taccount_id, taccount_id, Date.today).count + 1
    end
  
    # create identifier
    if self.use_requested_for
      ident = (self.created_at.strftime("%Y%m%d") + self.requested_for.initials + (self.seq.to_i+64).chr.to_s).downcase
    else
      ident = (self.created_at.strftime("%Y%m%d") + self.account.initials + (self.seq.to_i+64).chr.to_s).downcase
    end

    if self.identifier.nil? || self.identifier == '' || self.identifier != ident
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

    # update completion
    self.completion = [
      self.date_ordered.nil? ? 0 : 8,
      self.date_received.nil? ? 0 : 4,
      self.date_approved.nil? ? 0 : 2,
      self.submitted_at.nil? ? 0 : 1,
  ].sum()
  end

  def received?
    !self.received_by_id.nil?
  end

  def column_class
    two_weeks_ago = DateTime.now - 2.weeks
    four_weeks_ago = DateTime.now - 4.weeks
    not_finished = self.completion < 15
    if not_finished
      # if the order has not been received in the last four weeks and it has been orderd then set to danger
      if self.date_received.nil? && !self.date_ordered.nil? && self.date_ordered < four_weeks_ago
        return 'table-danger'
      # if the order has been created and not finished in the last four weeks then set to danger
      elsif self.created_at < four_weeks_ago
        return 'table-danger'
      # if the order has been received and not finished in the last two weeks then set to warning
      elsif self.created_at <  two_weeks_ago
        return 'table-warning'
      else
        return ''
      end
    else
      return 'table-success'
    end # not finished
  end
end
