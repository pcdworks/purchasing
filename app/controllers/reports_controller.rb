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

  end

  def itemized_requests_results
    @results = Request.where(@query)
    .includes(:items, :payment_method, :project)
    .order(identifier: :desc)
    .group_by(&:project)
    .collect  do |x|
      t = x[1].group_by(&:work_breakdown_structure)
      [x[0], t]
    end
  end

  def summarized_requests_results
    @results = Request.where(@query)
                      .includes(:items, :payment_method, :project)
                      .order(identifier: :desc)
                      .group_by(&:project)
                      .collect  do |x|
                        t = x[1].group_by(&:work_breakdown_structure)
                        [x[0], t]
                      end
  end

  private
    def set_query
      @query = {}
      @start_date = params[:start]
      @end_date = params[:end]
      @payment_methods = params[:payment_methods]
      @projects = params[:projects]
      @requested_by = params[:requested_by]
      @requested_for = params[:requested_for]

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
