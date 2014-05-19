require 'spec_helper'

module Jobbr

  describe Job do

    it "behaves consistently with polymorphism" do
      dummy_job = DelayedJobs::DummyJob.instance
      other_dummy_job = DelayedJobs::OtherDummyJob.instance

      Run::create(job: dummy_job)
      dummy_job.runs.should have(1).item
      other_dummy_job.runs.should have(0).item

      Run::create(job: other_dummy_job)
      dummy_job.runs.should have(1).item
      other_dummy_job.runs.should have(1).item
    end

    it "destroys related runs and logs when deleted" do
      expect {
        DelayedJobs::DummyJob.run({})
      }.to change { Job.all.count + Run.all.count + LogMessage.all.count }.from(0)

      expect {
        DelayedJobs::DummyJob.instance.delete
      }.to change { Job.all.count + Run.all.count + LogMessage.all.count }.to(0)
    end

  end
end
