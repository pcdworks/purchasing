class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy ]

  # GET /requests or /requests.json
  def index
    sort_order = [
      completion: :asc,
      created_at: :desc,
      seq: :desc
    ]
    if params[:query] and params[:query] != ''
      query = '%' + params[:query].to_s + '%'
      @requests = Request.joins(:items).includes(:items).where(
        'identifier ilike ?
        or vendor ilike ?
        or items.description ilike ?
        or items.vendor_reference ilike ?
        or work_breakdown_structure ilike ?',
        query,
        query,
        query,
        query,
        query
        ).order(*sort_order).page(params[:page])
    else
      @requests = Request.includes(:items).order(*sort_order).page(params[:page])
    end
  end

  # GET /requests/1 or /requests/1.json
  def show
    respond_to do |format|
      format.html
      format.ods do
        send_data build_request_ods(@request),
                  filename: "#{@request.identifier}.ods",
                  type: :ods
      end
    end
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if request_params[:attachment]
        type = :attached
      else
        type = nil
      end
      if @request.save
        send_mail(@request, type)
        format.html { redirect_to request_url(@request), notice: "Request was successfully created." }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      was_on_hold       = @request.on_hold?
      hold_until_param  = request_params[:on_hold_until]
      newly_on_hold     = !was_on_hold && hold_until_param.present?

      if request_params[:attachment]
        type = :attached
      elsif request_params[:submitted]
        type = :submitted
      elsif request_params[:approved]
        type = :approved
      elsif newly_on_hold
        type = :on_hold
      else
        type = nil
      end

      update_items(request_params)
      new_attachments = Array(request_params[:attachment]).compact_blank
      if @request.update(request_params.except(:received, :submitted, :approved, :attachment))
        @request.attachment.attach(new_attachments) if new_attachments.any?
        send_mail(@request, type)
        format.html { redirect_to request_url(@request), notice: "Request was successfully updated." }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url, notice: "Request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def build_request_ods(req)
      ss = RODF::Spreadsheet.new
      OdsStyles.apply(ss)

      meta = [
        ["Identifier",     req.identifier.to_s.upcase],
        ["Vendor",         req.vendor.to_s],
        ["Order Number",   req.order_number.to_s],
        ["Project",        req.project.to_s],
        ["WBS",            req.work_breakdown_structure.to_s],
        ["Payment Method", req.payment_method.to_s],
        ["Requested By",   req.account.to_s],
        ["Requested For",  req.requested_for.to_s],
        ["Date Created",   (req.created_at  ? req.created_at.to_date  : nil)],
        ["Date Ordered",   (req.date_ordered ? req.date_ordered.to_date : nil)],
        ["Date Received",  (req.date_received ? req.date_received.to_date : nil)],
        ["Date Approved",  (req.date_approved ? req.date_approved.to_date : nil)],
        ["Approved By",    req.approved_by.to_s],
      ]
      meta << ["On Hold Until", req.on_hold_until.to_date] if req.on_hold_until.present?

      totals = [
        ["Subtotal",   req.subtotal.to_f],
        ["Shipping",   req.shipping_cost.to_f],
        ["Sales Tax",  req.sales_tax.to_f],
        ["Import Tax", req.import_tax.to_f],
        ["Surcharge",  req.surcharge.to_f],
        ["Total",      req.total.to_f],
      ]

      ss.table(req.identifier.to_s.upcase) do |t|
        %w[4cm 8cm 4cm 1.5cm 3cm 3cm].each { |w| t.column style: OdsStyles.column_for(w) }

          meta.each do |label, value|
            t.row do |r|
              r.cell label, style: "subheader"
              if value.is_a?(Date)
                r.cell value, style: "cell", type: :date
              else
                r.cell value.to_s, style: "cell"
              end
            end
          end

          t.row { |r| r.cell "" }

          t.row do |r|
            %w[# Description VendorRef Qty Price Total].each do |h|
              r.cell h, style: "header"
            end
          end
          req.items.reverse.each_with_index do |item, idx|
            t.row do |r|
              r.cell idx + 1,                             style: "cell", type: :float
              r.cell item.description.to_s,               style: "cell"
              r.cell item.vendor_reference.to_s,          style: "cell"
              r.cell item.quantity.to_f,                  style: "cell", type: :float
              r.cell item.price.to_f, type: :currency,    style: "currency"
              r.cell item.total.to_f, type: :currency,    style: "currency"
            end
          end

          t.row { |r| r.cell "" }

          totals.each do |label, amount|
            style = label == "Total" ? "header" : "subheader"
            t.row do |r|
              4.times { r.cell "", style: style }
              r.cell label, style: style
              r.cell amount, type: :currency, style: style
            end
          end

          if req.notes.present?
            t.row { |r| r.cell "" }
            t.row do |r|
              r.cell "Notes", style: "subheader"
              r.cell req.notes.to_s, style: "cell"
            end
          end
          if req.reason_for_rejection.present?
            t.row do |r|
              r.cell "Reason for Rejection", style: "subheader"
              r.cell req.reason_for_rejection.to_s, style: "cell"
            end
          end

          if req.attachment.attached?
            t.row do |r|
              r.cell "Attachments", style: "header"
              r.cell "",            style: "header"
            end
            req.attachment.each do |att|
              url = Rails.application.routes.url_helpers.rails_blob_url(att, host: request.base_url)
              t.row do |r|
                r.cell style: "cell" do |c|
                  c.paragraph do |p|
                    p.link(att.filename.to_s, href: url)
                  end
                end
              end
            end
          end
      end
      ss.bytes
    end

    def update_items(request_params)
      received = request_params[:received]
      account_id = current_account.id
      status = request_params[:status].to_i
      now = DateTime.now
      unless received.nil?
        if ActiveModel::Type::Boolean.new.cast(received)
          @request.items.each do |item|
            if item.received_by_id.nil?
              item.received_by_id = account_id
              item.received_at = now
              item.save
            end
          end
        else
          @request.items.each do |item|
            item.received_by_id = nil
            item.received_at = nil
            item.save
          end
        end
        @request.status = status
      end
    end

    def send_mail(req, type)
      rm = RequestMailer.with(
        request: req,
        type: type,
        current_account: current_account).new_request_email.deliver_now
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_request
        @request = Request.find_by(identifier: params[:identifier])
        if @request.nil?
          @request = Request.find(params[:request][:id])
        end
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:id, :notes, :reason_for_rejection,
        :shipping_cost, :sales_tax, :import_tax, :date_received,
        :date_approved, :date_ordered, :order_number, :status,
        :approved_by_id, :work_breakdown_structure,
        :project_id, :payment_method_id, :account_id,
        :requested_for_id, :shipping_charges_paid_to, :vendor,
        :surcharge, :received_by_id, :identifier,
        :use_requested_for, :created_at,
        :submitted_at, :on_hold_until,
        # conditional params
        :submitted, :approved, :received,
        items_attributes: [:id, :description, :vendor_reference,
                           :quantity, :price, :received_by_id,
                           :received_at, :link, :_destroy],
        attachment: [])
    end
end
