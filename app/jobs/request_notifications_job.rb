# Daily nag job: digests of pending purchase requests + expired-hold cleanup.
#
# Hold expiry runs first: any Request whose on_hold_until is in the past gets
# its hold cleared, and the appropriate audience is notified that the hold
# ended (approvers if the PR was not approved, owner+requested_for otherwise).
#
# Then digest emails:
# - Red (table-danger) PRs are notified every run.
# - Yellow (table-warning) PRs are only notified on Mondays.
# - PRs that are submitted but not yet approved are sent to ALL approvers;
#   everything else is sent to the request's owner (account_id).
# On-hold PRs are skipped because Request#column_class returns "" while held.
class RequestNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    process_expired_holds
    process_pending_digests
  end

  private

  def process_expired_holds
    Request.where.not(on_hold_until: nil)
           .where("on_hold_until <= ?", Time.current)
           .find_each do |req|
      type = req.approved? ? :hold_expired_owner : :hold_expired_approver
      # The mailer already routes to the full audience (all approvers, or
      # account+requested_for). call it once. current_account is required
      # by the mailer but isn't used for these types' recipient list.
      RequestMailer.with(request: req, type: type, current_account: req.account)
                   .new_request_email.deliver_later
      req.update_column(:on_hold_until, nil)
    end
  end

  def process_pending_digests
    monday = Date.current.monday?

    pending = Request
                .where("completion < ?", Request::COMPLETE_FLAG_TOTAL)
                .includes(:account, :requested_for, :payment_method, project: [:client])

    owner_buckets    = Hash.new { |h, k| h[k] = [] } # account => [requests]
    approver_pending = []

    pending.find_each do |req|
      cls = req.column_class
      next if cls.blank?
      next if cls == "table-warning" && !monday

      if req.submitted? && !req.approved?
        approver_pending << req
      else
        owner_buckets[req.account] << req
      end
    end

    owner_buckets.each do |account, requests|
      next if account.nil? || account.email.blank?
      RequestMailer.with(account: account, requests: requests).pending_digest.deliver_later
    end

    if approver_pending.any?
      Account.where(approver: true).where.not(email: [nil, ""]).find_each do |approver|
        RequestMailer.with(account: approver, requests: approver_pending).approver_digest.deliver_later
      end
    end
  end
end

