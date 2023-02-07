class RequestMailer < ApplicationMailer
    default :from => ENV['MAILER_FROM'],
            :reply_to => ENV['MAILER_FROM']
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
        end # @type
    end
end
