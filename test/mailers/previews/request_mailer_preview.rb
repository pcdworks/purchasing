# Preview all emails at http://localhost:3000/rails/mailers/request_mailer
class RequestMailerPreview < ActionMailer::Preview
    def new_request_email
        # Set up a temporary order for the preview
        request = Request.first
    
        RequestMailer.with(request: request, type: nil).new_request_email
      end
end
