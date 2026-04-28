class ReportsController < ApplicationController
  before_action :set_query, only: [:builder, :payment_method_results, :itemized_requests_results, :summarized_requests_results]
  def index
  end

  def builder
    @type = params[:type]
    p = request.parameters.except(:type, :action, :controller)
    # switch to the requested report type
    if @type == 'payment_method'
      redirect_to reports_payment_method_results_path(p)
    elsif @type == 'itemized_requests'
      redirect_to reports_itemized_requests_results_path(p)
    elsif @type == 'summarized_requests'
      redirect_to reports_summarized_requests_results_path(p)
    end
  end

  def payment_method_results
    @total = 0.0
    @results = Request.where(@query)
                      .includes(:items, :payment_method, :project)
                      .order('payment_methods.title ASC')
                      .group_by(&:payment_method)
                      .collect  do |x|
                        t = x[1].sum(&:total)
                        @total += t
                        [x[0], t]
                      end

    respond_to do |format|
      format.html
      format.ods do
        send_data build_payment_method_ods, filename: ods_filename("payment-method"), type: :ods
      end
    end
  end

  def itemized_requests_results
    @results = Request.where(@query)
    .includes(:items, :payment_method, project: [:client])
    .order("clients.title asc, projects.identifier asc, projects.title asc, requests.identifier desc")
    .group_by(&:project)
    .collect  do |x|
      t = x[1].group_by(&:work_breakdown_structure)
      [x[0], t]
    end

    respond_to do |format|
      format.html
      format.ods do
        send_data build_itemized_requests_ods, filename: ods_filename("itemized-requests"), type: :ods
      end
    end
  end

  def summarized_requests_results
    @results = Request.where(@query)
                      .includes(:items, :payment_method, project: [:client])
                      .order("clients.title asc, projects.identifier asc, projects.title asc, requests.identifier desc")
                      .group_by(&:project)
                      .collect  do |x|
                        t = x[1].group_by(&:work_breakdown_structure)
                        [x[0], t]
                      end

    respond_to do |format|
      format.html
      format.ods do
        send_data build_summarized_requests_ods, filename: ods_filename("summarized-requests"), type: :ods
      end
    end
  end

  private
    def ods_filename(slug)
      range = [@start_date, @end_date].compact.join("_to_")
      base  = ["report", slug, range].reject(&:blank?).join("-")
      "#{base}.ods"
    end

    def build_payment_method_ods
      ss = RODF::Spreadsheet.new
      OdsStyles.apply(ss)

      ss.table("Payment Method") do |t|
        %w[8cm 4cm].each { |w| t.column style: OdsStyles.column_for(w) }

        t.row do |r|
          r.cell "Payment Method", style: "header"
          r.cell "Total",          style: "header"
        end
        @results.each do |pm, total|
          t.row do |r|
            r.cell pm.to_s,            style: "cell"
            r.cell total.to_f, type: :currency, style: "currency"
          end
        end
        t.row do |r|
          r.cell "Total",              style: "total"
          r.cell @total.to_f, type: :currency, style: "total"
        end
      end
      ss.bytes
    end

    def build_summarized_requests_ods
      ss = RODF::Spreadsheet.new
      OdsStyles.apply(ss)

      ss.table("Summarized Requests") do |t|
        %w[5cm 4cm 3.5cm 5cm 2.5cm 3cm].each { |w| t.column style: OdsStyles.column_for(w) }

        t.row do |r|
          %w[Project WBS Identifier Vendor Date Cost].each do |h|
            r.cell h, style: "header"
          end
        end

        @results.each do |project, wbs_groups|
          wbs_groups.each do |wbs, requests|
            requests.each do |q|
              t.row do |r|
                r.cell project.to_s,                   style: "cell"
                r.cell wbs.presence || "Undefined",    style: "cell"
                r.cell q.identifier.to_s.upcase,       style: "cell"
                r.cell q.vendor.to_s,                  style: "cell"
                r.cell q.created_at.to_date,           style: "cell", type: :date
                r.cell q.total.to_f, type: :currency,  style: "currency"
              end
            end
          end
        end
      end
      ss.bytes
    end

    def build_itemized_requests_ods
      ss = RODF::Spreadsheet.new
      OdsStyles.apply(ss)

      ss.table("Itemized Requests") do |t|
        %w[4.5cm 3.5cm 3cm 4.5cm 2.5cm 2.5cm 1cm 6cm 3cm 1.5cm 2.5cm 2.5cm].each do |w|
          t.column style: OdsStyles.column_for(w)
        end

        t.row do |r|
          %w[Project WBS Request Vendor DateOrdered DateReceived # Description VendorRef Qty Price Total].each do |h|
            r.cell h, style: "header"
          end
        end

        @results.each do |project, wbs_groups|
          wbs_groups.each do |wbs, requests|
            requests.each do |q|
              q.items.reverse.each_with_index do |item, idx|
                t.row do |r|
                  r.cell project.to_s,                       style: "cell"
                  r.cell wbs.presence || "Undefined",        style: "cell"
                  r.cell q.identifier.to_s.upcase,           style: "cell"
                  r.cell q.vendor.to_s,                      style: "cell"
                  r.cell (q.date_ordered ? q.date_ordered.to_date : ""),  style: "cell", type: q.date_ordered ? :date : :string
                  r.cell (q.date_received ? q.date_received.to_date : ""), style: "cell", type: q.date_received ? :date : :string
                  r.cell idx + 1,                            style: "cell", type: :float
                  r.cell item.description.to_s,              style: "cell"
                  r.cell item.vendor_reference.to_s,         style: "cell"
                  r.cell item.quantity.to_f,                 style: "cell", type: :float
                  r.cell item.price.to_f, type: :currency,   style: "currency"
                  r.cell item.total.to_f, type: :currency,   style: "currency"
                end
              end
            end
          end
        end
      end
      ss.bytes
    end

    def set_query
      @query = {}
      @start_date = params[:start]
      @end_date = params[:end]
      @payment_methods = params[:payment_methods]
      @projects = params[:projects]
      @requested_by = params[:requested_by]
      @requested_for = params[:requested_for]

      @query[:completion] = 11,15
      if @start_date.present? && @end_date.present? && !@start_date.nil? && !@end_date.nil?
        @query[:created_at] = Date.parse(@start_date).beginning_of_day..Date.parse(@end_date).end_of_day
      end
      if @payment_methods.present? && !@payment_methods.reject{|c| c.empty?}.empty?
        @query[:payment_method_id] = @payment_methods
      end
      if @projects.present? && !@projects.reject{|c| c.empty?}.empty?
        @query[:project_id] =  @projects
      end
      if @requested_by.present? && !@requested_by.reject{|c| c.empty?}.empty?
        @query[:account_id] = @requested_by
      end
      if @requested_for.present? && !@requested_for.reject{|c| c.empty?}.empty?
        @query[:requested_for_id] = @requested_for
      end
    end

end
