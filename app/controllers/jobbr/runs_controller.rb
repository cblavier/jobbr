require 'jobbr/application_controller'

module Jobbr

  class RunsController < ApplicationController

    def show
      @job = Job.by_name(params[:job_id]).first
      @run = @job.runs.where(id: params[:id]).first
    end

  end

end