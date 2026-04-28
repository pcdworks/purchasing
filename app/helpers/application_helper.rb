module ApplicationHelper
  # Human-readable description of what stage a request is stuck at,
  # derived from its `completion` bitfield.
  # 1 = submitted, 2 = approved, 4 = all-items received-or-returned, 8 = ordered.
  def request_status_label(request)
    return "Complete" if request.completion.to_i >= Request::COMPLETE_FLAG_TOTAL

    parts = []
    parts << "needs to be submitted"   if request.submitted_at.nil?
    parts << "awaiting approval"       if request.submitted_at.present? && request.date_approved.nil?
    parts << "needs to be ordered"     if request.date_approved.present? && request.date_ordered.nil?
    parts << "awaiting items received" if request.date_ordered.present? && !request.received_or_returned?
    parts.first || "Pending"
  end
end
