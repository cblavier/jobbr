require 'spec_helper'

module Jobbr

  describe DelayedJob do

    it 'creates a new job by its name' do
      expect {
        DelayedJob.run_delayed_by_name('delayed_jobs/dummy_job', {}, false)
      }.to change{ DelayedJobs::DummyJob.all.count }.by(1)

      job = DelayedJobs::DummyJob.all.first
      job.runs.count.should == 1
      job.runs.first.messages.count.should == 1
    end

    it 'does not create duplicated name jobs' do
      expect {
        DelayedJob.run_delayed_by_name('delayed_jobs/dummy_job', {}, false)
        DelayedJob.run_delayed_by_name('delayed_jobs/dummy_job', {}, false)
        DelayedJob.run_delayed_by_name('delayed_jobs/dummy_job', {}, false)
      }.to change{ DelayedJob.count }.by(1)
      
      expect {
        DelayedJob.run_delayed_by_name('delayed_jobs/other_dummy_job', {}, false)
        DelayedJob.run_delayed_by_name('delayed_jobs/other_dummy_job', {}, false)
      }.to change{ DelayedJob.count }.by(1)
    end

  end

end
