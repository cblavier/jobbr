require 'spec_helper'

module Jobbr

  describe Job do

    it "behaves consistently with polymorphism" do
      dummy_job = DelayedJobs::DummyJob.instance
      other_dummy_job = DelayedJobs::OtherDummyJob.instance

      Run::create(job: dummy_job)
      expect(dummy_job.runs.size).to be(1)
      expect(other_dummy_job.runs.size).to be(0)

      Run::create(job: other_dummy_job)
      expect(dummy_job.runs.size).to be(1)
      expect(other_dummy_job.runs.size).to be(1)
    end

    it "destroys related runs and logs when deleted" do
      expect {
        DelayedJobs::DummyJob.run({})
      }.to change { Job.all.count + Run.all.count + LogMessage.all.count }.from(0)

      expect {
        DelayedJobs::DummyJob.instance.delete
      }.to change { Job.all.count + Run.all.count + LogMessage.all.count }.to(0)
    end

    it "consistently pass params to jobs" do
      params = {foo: 1, bar: 2}
      DelayedJobs::DummyJob.any_instance.expects(:perform).with(instance_of(Jobbr::Run), params)
      DelayedJobs::DummyJob.run(params)
    end

  end
end
