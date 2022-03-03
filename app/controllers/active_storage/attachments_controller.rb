# app/controllers/active_storage/attachments_controller.rb
class ActiveStorage::AttachmentsController < ApplicationController
    before_action :set_attachment, only: %i[ destroy ]

    def destroy
        @attachment.purge_later
    end

    private

    def set_attachment
        @attachment = ActiveStorage::Attachment.find(params[:id])
        @record = @attachment.record
    end
end