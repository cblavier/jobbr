module Jobbr

  class DelayedJobsController < Jobbr::ApplicationController

    def create
      params.merge!(current_user_id: current_user.id) rescue nil
      @job = Job.run_by_name(params[:job_name], params)
      render json: { id: @job.id.to_s }
    end

    def show
      job_run = Run[params[:id]]
      render json: { status: job_run.status, result: job_run.result, progress: job_run.progress }
    end

  end

end
