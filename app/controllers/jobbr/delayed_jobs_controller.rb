module Jobbr

  class DelayedJobsController < Jobbr::ApplicationController

    def create
      params.merge!(current_user_id: current_user.id.to_s) rescue nil
      @run = Job.run_by_name(params[:job_name], params)
      render json: { id: @run.id.to_s }
    end

    def show
      job_run = Run[params[:id]]
      render json: job_run.to_hash
    end

  end

end
