require 'spec_helper'

module Jobbr

  describe ScheduledJob do

    it 'creates a new job by its name' do
      expect {
        ScheduledJobs::DummyScheduledJob.run
      }.to change{ ScheduledJob.count }.by(1)
    end

    it 'does not create duplicated name jobs' do
      expect {
        ScheduledJobs::DummyScheduledJob.run
        ScheduledJobs::DummyScheduledJob.run
        ScheduledJobs::DummyScheduledJob.run
      }.to change{ ScheduledJob.count }.by(1)
      expect {
        ScheduledJobs::DummyJob.run
        ScheduledJobs::DummyJob.run
      }.to change{ ScheduledJob.count }.by(1)
    end

    it 'creates a job run for each run' do
      ScheduledJobs::DummyScheduledJob.run
      job = ScheduledJobs::DummyScheduledJob.all.first

      expect {
        ScheduledJobs::DummyScheduledJob.run
        ScheduledJobs::DummyScheduledJob.run
      }.to change{ job.runs.count }.from(1).to(3)
    end

    it 'does not create more run than max_run_per_job' do
      ScheduledJobs::DummyScheduledJob.run
      job = ScheduledJobs::DummyScheduledJob.all.first
      first_run = job.runs.first
      max_run_per_job = 5
      ScheduledJobs::DummyScheduledJob.any_instance.stubs(:max_run_per_job).returns(max_run_per_job)

      expect {
        (max_run_per_job + 3).times do
          ScheduledJobs::DummyScheduledJob.run
        end
      }.to change{ job.runs.count }.from(1).to(max_run_per_job)

      # ensure that it removes first executions and not latest
      job.runs.should_not include(first_run)
    end

    it 'changes run status from running to success' do
      ScheduledJobs::DummyScheduledJob.run do
        ScheduledJobs::DummyScheduledJob.all.first.runs.first.status.should be :running
      end
      ScheduledJobs::DummyScheduledJob.all.first.runs.first.status.should be :success
    end

    it 'changes run status from running to failure in case of exception' do
      ScheduledJobs::DummyScheduledJob.any_instance.stubs(:perform).raises('an error')
      begin
        ScheduledJobs::DummyScheduledJob.run
      rescue Exception
      end
      ScheduledJobs::DummyScheduledJob.all.first.runs.first.status.should be :failure
    end

    it 'sets runni#ng dates' do
      ScheduledJobs::DummyScheduledJob.run
      job_run = ScheduledJobs::DummyScheduledJob.all.first.runs.first
      job_run.started_at.should_not be_nil
      job_run.finished_at.should_not be_nil
    end

    it 'sets the progress to 100% at the end' do
      ScheduledJobs::DummyScheduledJob.run
      ScheduledJobs::DummyScheduledJob.all.first.runs.first.progress.should be 100
    end

    it 'creates log messages when logging' do
      ScheduledJobs::LoggingJob.run
      last_job_run = ScheduledJobs::LoggingJob.all.first.runs.first
      last_job_run.should have(2).messages
      last_job_run.messages[1].kind.should be :debug
      last_job_run.messages[1].message.should == 'foo'
      last_job_run.messages[2].kind.should be :error
      last_job_run.messages[2].message.should == 'bar'
    end

  end

end
