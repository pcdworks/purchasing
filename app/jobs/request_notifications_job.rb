# Daily nag job: digests of pending purchase requests.
#
# - Red (table-danger) PRs are notified every run.
# - Yellow (table-warning) PRs are only notified on Mondays.
# - PRs that are submitted but not yet approved are sent to ALL approvers;
#   everything else is sent to the request's owner (account_id).
class RequestNotificationsJob < ApplicationJob
  queue_as :default

  def perform
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
