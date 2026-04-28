class RequestMailer < ApplicationMailer
    default :from => ENV['MAILER_FROM'],
            :reply_to => ENV['MAILER_FROM']

    # Daily/weekly digest to a request owner with their pending PRs.
    def pending_digest
      @account  = params[:account]
      @requests = Array(params[:requests]).sort_by { |r| [r.column_class == "table-danger" ? 0 : 1, r.created_at] }
      return if @requests.empty?

      mail(
        to: @account.email,
        subject: "You have #{@requests.size} pending purchase #{'request'.pluralize(@requests.size)}"
      )
    end

    # Daily/weekly digest to an approver listing PRs awaiting approval.
    def approver_digest
      @account  = params[:account]
      @requests = Array(params[:requests]).sort_by { |r| [r.column_class == "table-danger" ? 0 : 1, r.created_at] }
      return if @requests.empty?

      mail(
        to: @account.email,
        subject: "#{@requests.size} purchase #{'request'.pluralize(@requests.size)} awaiting approval"
      )
    end

    def new_request_email
        @request = params[:request]
        @type = params[:type]

        @current_account = params[:current_account].email
        @requested_for = @request.requested_for.email
        @requested_by = @request.account.email
        @from = ENV['MAILER_FROM']

        case @type
            when :submitted
                @to = Account.where(approver: true).pluck(:email).join(',')
                mail(
                    from: @from,
                    reply_to: @from,
                    to: @to,
                    subject: "A new purchase request is awaiting approval: " + @request.to_s
                )
            when :approved
                mail(
                    from: @from,
                    reply_to: @from,
                    to: @requested_by,
                    cc: @requested_for,
                    subject: "Purchase request has been approved: " + @request.to_s
                )
            when :received
                if @current_account != @requested_by && @current_account != @requested_for
                    @to = @requested_by
                    @cc = @requested_for
                elsif @current_account == @requested_by && @current_account != @requested_for
                    @to = @requested_for
                    @cc = @requested_for
                elsif @current_account == @requested_for && @current_account != @requested_by
                    @to = @requested_by
                    @cc = @requested_by
                end
                r = @request.received
                if r[:all]
                    @subject = "Everything has been received for: " + @request.to_s
                elsif r[:some]
                    @subject = "Some of the items have been received for: " + @request.to_s
                end
                if @to && @cc && @subject
                    mail(
                        from: @from,
                        reply_to: @from,
                        to: @to,
                        cc: @cc,
                        subject: @subject
                    )
                end # @to && @cc
            when :attached
                @to = Account.all.select { |a| a.validator?  }.pluck(:email).join(',')
                if not @to.include?(@current_account)
                    mail(
                        from: @from,
                        reply_to: @from,
                        to: @to,
                        subject: "An attachment has been added to the purchase request: " + @request.to_s
                    )
                end
            when :on_hold
                @to = [@requested_by, @requested_for].uniq.join(',')
                mail(
                    from: @from,
                    reply_to: @from,
                    to: @to,
                    subject: "Purchase request put on hold: " + @request.to_s
                )
            when :hold_expired_approver
                @to = Account.where(approver: true).pluck(:email).join(',')
                mail(
                    from: @from,
                    reply_to: @from,
                    to: @to,
                    subject: "Hold ended, awaits approval: " + @request.to_s
                )
            when :hold_expired_owner
                @to = [@requested_by, @requested_for].uniq.join(',')
                mail(
                    from: @from,
                    reply_to: @from,
                    to: @to,
                    subject: "Hold ended, ready for next step: " + @request.to_s
                )
        end # @type
    end
end
