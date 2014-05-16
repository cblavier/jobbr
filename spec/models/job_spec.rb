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

  end

end
