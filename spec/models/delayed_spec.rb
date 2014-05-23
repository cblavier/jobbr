require 'spec_helper'

module Jobbr

  describe Delayed do

    it 'creates a new job by its name' do
      expect {
        Job.run_by_name('delayed_jobs/dummy_job', {}, false)
      }.to change{ Job.count }.by(1)

      job = DelayedJobs::DummyJob.instance
      job.runs.count.should == 1
      job.runs.first.messages.count.should == 2
    end

    it 'does not create duplicated name jobs' do
      expect {
        Job.run_by_name('delayed_jobs/dummy_job', {}, false)
        Job.run_by_name('delayed_jobs/dummy_job', {}, false)
        Job.run_by_name('delayed_jobs/dummy_job', {}, false)
      }.to change{ Job.all.count }.by(1)

      expect {
        Job.run_by_name('delayed_jobs/other_dummy_job', {}, false)
        Job.run_by_name('delayed_jobs/other_dummy_job', {}, false)
      }.to change{ Job.all.count }.by(1)
    end

  end

end
