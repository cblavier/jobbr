require 'spec_helper'

module Jobbr

  describe DelayedJobsController do

    routes { Jobbr::Engine.routes }

    it 'creates a new job by its name' do
      expect {
        post :create, {job_name: 'delayed_jobs/dummy_job'}
      }.to change{ Job.count }.by(1)

      job = DelayedJobs::DummyJob.instance
      job.runs.count.should == 1

      JSON.parse(response.body)['id'].should == job.runs.first.id
    end

    it 'returns a job run status' do
      DelayedJobs::DummyJob.run({})

      run = Run.all.first
      get :show, {id: run.id}

      json = JSON.parse(response.body)
      json['name'].should == 'dummy'
      json['status'].should == 'success'
      json['progress'].should == 100
      json['result'].should be_nil
    end

  end

end
