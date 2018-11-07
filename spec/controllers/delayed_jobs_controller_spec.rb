require 'spec_helper'

module Jobbr

  describe DelayedJobsController do

    routes { Jobbr::Engine.routes }

    it 'creates a new job by its name' do
      expect {
        post :create, params: {job_name: 'delayed_jobs/dummy_job'}
      }.to change{ Job.count }.by(1)

      job = DelayedJobs::DummyJob.instance
      expect(job.runs.count).to be(1)
      expect(JSON.parse(response.body)['id']).to eq(job.runs.first.id)
    end

    it 'returns a job run status' do
      DelayedJobs::DummyJob.run({})

      run = Run.all.first
      get :show, params: {id: run.id}

      json = JSON.parse(response.body)
      expect(json['name']).to eq('dummy')
      expect(json['status']).to eq('success')
      expect(json['progress']).to be(100)
      expect(json['result']).to be_nil
    end

  end

end
