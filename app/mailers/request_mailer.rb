class RequestMailer < ApplicationMailer
    default :from => ENV['MAILER_USER_NAME']
    def new_request_email
        @request = params[:request]
        @type = params[:type]

        @current_account = params[:current_account].email
        @requested_for = @request.requested_for.email
        @requested_by = @request.account.email
        @from = ENV['MAILER_USER_NAME']

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

        if @to && @cc
        case @type
            when nil
                case @request.status
                when 1
                    Account.where(approver: true).each do |account|
                        mail(
                            from: @from,
                            to: account.email,
                            subject: "A new purchase request is awaiting approval: " + @request.to_s
                        )
                    end
                when 2
                    mail(
                        from: @from,
                        to: @to,
                        cc: @cc,
                        subject: "Purchase request has been approved: " + @request.to_s
                    )
                end # status
            when :received
                mail(
                    from: @from,
                    to: @to,
                    cc: @cc,
                    subject: "Everything has been received for: " + @request.to_s
                )
            when :partial_received
                mail(
                    from: @from,
                    to: @to,
                    cc: @cc,
                    subject: "Some item(s) have been received for: " + @request.to_s
                )
            when :attached
                Account.all.select { |a| a.validator?  }.each do |account|
                    mail(
                        from: @from,
                        to: account.email,
                        subject: "An attachment has been added to the purchase request: " + @request.to_s
                    )
                end
            end # @type
        end # @to && @cc
    end
end
