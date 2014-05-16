module Jobbr

  class JobsController < Jobbr::ApplicationController

    def index
      @scheduled_jobs = Jobbr::Job.scheduled
      @delayed_jobs = Jobbr::Job.delayed
    end

    def show
      logger.debug "toto"
      logger.debug params[:id]
      if @job = Job.by_name(params[:id])
        @runs = @job.ordered_runs
        @last_run = @job.last_run
      end
    end

  end

end
