require 'enginedemo/application_controller'

module Jobbr

  class DelayedJobsController < ApplicationController

    def create
      @job = DelayedJob.run_delayed_by_name(params[:job_name], params)
      render json: { id: @job.id }
    end

    def show
      job_run = Run.find(params[:id])
      render json: { status: job_run.status, result: job_run.result, progress: job_run.progress }
    end

  end

end