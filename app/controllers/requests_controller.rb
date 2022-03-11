class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy ]

  # GET /requests or /requests.json
  def index
    @requests = Request.all.order(created_at: :desc)
  end

  # GET /requests/1 or /requests/1.json
  def show
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
      if @request.save
        send_mail(@request)
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
      update_items(request_params)
      if @request.update(request_params.except(:received))
        send_mail(@request)
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
            puts "nilling"
            item.received_by_id = nil
            item.received_at = nil
            item.save
          end
        end
        @request.status = status
      end
    end

    def send_mail(req)
      rm = RequestMailer.with(request: req).new_request_email.deliver_now
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find_by(identifier: params[:identifier])
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:notes, :reason_for_rejection,
        :shipping_cost, :sales_tax, :import_tax, :date_received,
        :date_approved, :date_ordered, :order_number, :status,
        :approved_by_id, :work_breakdown_structure,
        :project_id, :payment_method_id, :account_id,
        :requested_for_id, :shipping_charges_paid_to, :vendor,
        :surcharge, :received_by_id, :identifier,
        :received,
        items_attributes: [:id, :description, :vendor_reference,
                           :quantity, :price, :received_by_id,
                           :received_at, :link, :_destroy],
        attachment: [])
    end
end
