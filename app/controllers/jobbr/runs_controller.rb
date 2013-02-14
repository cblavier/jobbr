module Jobbr

  class RunsController < Jobbr::ApplicationController

    def show
      @job = Job.by_name(params[:job_id]).first
      @run = @job.runs.where(id: params[:id]).unscoped.first
    end

  end

end