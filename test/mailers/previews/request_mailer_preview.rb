# Preview all emails at http://localhost:3000/rails/mailers/request_mailer
class RequestMailerPreview < ActionMailer::Preview
  def new_request_email_submitted
    new_request_email_with(:submitted)
  end

  def new_request_email_approved
    new_request_email_with(:approved)
  end

  def new_request_email_received_all
    received_email_preview(all: true)
  end

  def new_request_email_received_some
    received_email_preview(all: false)
  end

  def new_request_email_attached
    new_request_email_with(:attached)
  end

  def new_request_email_on_hold
    request = Request.first
    request.define_singleton_method(:on_hold_until) { 2.weeks.from_now }
    RequestMailer
      .with(request: request, type: :on_hold, current_account: Account.first)
      .new_request_email
  end

  def new_request_email_hold_expired_approver
    new_request_email_with(:hold_expired_approver)
  end

  def new_request_email_hold_expired_owner
    new_request_email_with(:hold_expired_owner)
  end

  def pending_digest
    account = Account.first
    requests = pending_requests_for_preview
    RequestMailer.with(account: account, requests: requests).pending_digest
  end

  def approver_digest
    account = Account.where(approver: true).first || Account.first
    requests = pending_requests_for_preview.select { |r| r.submitted? && !r.approved? }
    requests = pending_requests_for_preview if requests.empty?
    RequestMailer.with(account: account, requests: requests).approver_digest
  end

  private

  def received_email_preview(all:)
    request = Request.first
    request.define_singleton_method(:received) { { all: all, some: !all } }
    # The mailer's routing only sets to/cc when current_account differs from the
    # requesters; force a distinct preview address so the branch fires.
    current_account = Account.new(email: "preview@example.com")
    RequestMailer
      .with(request: request, type: :received, current_account: current_account)
      .new_request_email
  end

  def new_request_email_with(type)
    request = Request.first
    current_account = Account.first
    RequestMailer
      .with(request: request, type: type, current_account: current_account)
      .new_request_email
  end

  # Pull anything that has a non-blank column_class so the preview always
  # renders rows. Falls back to Request.first(3) if nothing is stale.
  def pending_requests_for_preview
    candidates = Request.where("completion < ?", Request::COMPLETE_FLAG_TOTAL)
                        .select { |r| r.column_class.present? }
    candidates.any? ? candidates : Request.limit(3).to_a
  end
end
