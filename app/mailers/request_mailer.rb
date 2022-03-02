class RequestMailer < ApplicationMailer
    default :from => ENV['MAILER_USER_NAME']
    def new_request_email
        @request = params[:request]
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
        end
    end
end
