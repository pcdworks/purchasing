class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  def browsers
  end

  def work_breakdown_structures
    if params['project_id'].to_i > 0
      @wbs = Request.where(project_id: params['project_id'].to_i).pluck(:work_breakdown_structure).uniq
    else
      @wbs = []
    end
    respond_to do |format|
      format.js {render json: @wbs.to_json }
    end
  end
end
