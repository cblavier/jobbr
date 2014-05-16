module Jobbr

  class RunsController < Jobbr::ApplicationController

    def show
      @job = Job.by_name(params[:job_id])
      @run = @job.runs[params[:id]]
    end

  end

end
