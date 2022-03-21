class RequestMailer < ApplicationMailer
    default :from => ENV['MAILER_USER_NAME']
    def new_request_email
        @request = params[:request]
        @type = params[:type]
        case @type
        when nil
            case @request.status
            when 1
                Account.where(approver: true).each do |account|
                    mail(
                        from: ENV['MAILER_USER_NAME'],
                        to: account.email,
                        subject: "A new purchase request is awaiting approval: " + @request.to_s
                    )
                end
            when 2
                mail(
                    from: ENV['MAILER_USER_NAME'],
                    to: @request.account.email,
                    cc: @request.requested_for.email,
                    subject: "Purchase request has been approved: " + @request.to_s
                )
            end # status
        when :received
            mail(
                from: ENV['MAILER_USER_NAME'],
                to: @request.account.email,
                cc: @request.requested_for.email,
                subject: "Everything has been received for: " + @request.to_s
            )
        when :partial_received
            mail(
                from: ENV['MAILER_USER_NAME'],
                to: @request.account.email,
                cc: @request.requested_for.email,
                subject: "Some item(s) have been received for: " + @request.to_s
            )
        end # @type
    end
end
