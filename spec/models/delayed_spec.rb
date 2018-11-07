require 'spec_helper'

module Jobbr

  describe Delayed do

    it 'creates a new job by its name' do
      expect {
        Job.run_by_name('delayed_jobs/dummy_job', {})
      }.to change{ Job.count }.by(1)

      job = DelayedJobs::DummyJob.instance
      expect(job.runs.count).to be(1)
      expect(job.runs.first.messages.count).to be(2)
    end

    it 'does not create duplicated name jobs' do
      expect {
        Job.run_by_name('delayed_jobs/dummy_job', {})
        Job.run_by_name('delayed_jobs/dummy_job', {})
        Job.run_by_name('delayed_jobs/dummy_job', {})
      }.to change{ Job.all.count }.by(1)

      expect {
        Job.run_by_name('delayed_jobs/other_dummy_job', {})
        Job.run_by_name('delayed_jobs/other_dummy_job', {})
      }.to change{ Job.all.count }.by(1)
    end

  end

end
