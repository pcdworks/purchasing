class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  after_action :check_request, only: %i[ update ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to request_url(@item.request), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def send_mail(req, type)
      rm = RequestMailer.with(
        request: req,
        type: type,
        current_account: current_account).new_request_email.deliver_now
    end

    def check_request
      request = @item.request
      dates = request.items.map(&:received_at)
      past_time = DateTime.now - 10.minutes

      send_it = dates.collect do |d|
        !d.nil? && d > past_time
      end.count(true) == 1

      # nothing is received
      if dates.all?(&:nil?)
        unless request.status == 4 && request.received_by_id.nil? && request.date_received.nil?
          request.status = 4
          request.received_by_id = nil
          request.date_received = nil
          request.save
        end
      # everything is receivied
      elsif dates.none?(&:nil?)
        unless request.status == 5 && !request.received_by_id.nil? && !request.date_received.nil?
          request.status = 5
          request.received_by_id = current_account.id
          request.date_received = DateTime.now
          if send_it
            send_mail(request, :received)
          end
          request.save
        end

      # must be partial
      else
        # don't save unless you have to
        unless request.status == 6
          request.status = 6
          if send_it
            send_mail(request, :partial_received)
          end
          request.save
        end
      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:id, :description, :vendor_reference,
                                   :quantity, :price, :received_by_id,
                                   :received_at, :link)
    end
end
