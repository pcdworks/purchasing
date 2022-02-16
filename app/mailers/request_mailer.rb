class RequestMailer < ApplicationMailer
    def new_request_email
        @request = params[:request]
    
        Account.where(approver: true).each do |account|
            mail(to: account.email,
            subject: "You've got a new purchase request: " + @request.to_s)
        end

    end
end
