require 'jobbr/application_controller'

module Jobbr

  class JobsController < ApplicationController

    def index
      @scheduled_jobs = Jobbr::ScheduledJob.all
      @delayed_jobs = Jobbr::DelayedJob.all
    end

    def show
      @job = Job.by_name(params[:id]).first
      @runs = Run.for_job(@job)
    end

  end

end