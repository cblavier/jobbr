require 'spec_helper'

module Jobbr

  describe Scheduled do

    it 'creates a new job by its name' do
      expect {
        ScheduledJobs::DummyScheduledJob.run
        job = ScheduledJobs::DummyScheduledJob.instance
      }.to change{ Job.all.count }.by(1)
      .and change {Jobbr::Job.scheduled.count}.by(1)
    end

    it 'does not create duplicated name jobs' do
      expect {
        ScheduledJobs::DummyScheduledJob.run
        ScheduledJobs::DummyScheduledJob.run
        ScheduledJobs::DummyScheduledJob.run
      }.to change{ Job.all.count }.by(1)
      expect {
        ScheduledJobs::DummyJob.run
        ScheduledJobs::DummyJob.run
      }.to change{ Job.all.count }.by(1)
    end

    it 'creates a job run for each run' do
      ScheduledJobs::DummyScheduledJob.run
      job = ScheduledJobs::DummyScheduledJob.instance

      expect {
        ScheduledJobs::DummyScheduledJob.run
        ScheduledJobs::DummyScheduledJob.run
      }.to change{ job.runs.count }.from(1).to(3)
    end

    it 'does not create more run than max_run_per_job' do
      ScheduledJobs::DummyScheduledJob.run
      job = ScheduledJobs::DummyScheduledJob.instance
      first_run = job.runs.first
      max_run_per_job = 5
      Job.any_instance.stubs(:max_run_per_job).returns(max_run_per_job)

      expect {
        (max_run_per_job + 3).times do
          ScheduledJobs::DummyScheduledJob.run
        end
      }.to change{ job.runs.count }.from(1).to(max_run_per_job)

      # ensure that it removes first executions and not latest
      expect(job.runs).not_to include(first_run)
    end

    it 'changes run status from running to success' do
      ScheduledJobs::DummyScheduledJob.run do
        expect(ScheduledJobs::DummyScheduledJob.instance.runs.first.status).to be :running
      end
      expect(ScheduledJobs::DummyScheduledJob.instance.runs.first.status).to be :success
    end

    it 'changes run status from running to failed in case of exception' do
      ScheduledJobs::DummyScheduledJob.any_instance.stubs(:perform).raises('an error')
      begin
        ScheduledJobs::DummyScheduledJob.run
      rescue Exception
      end
      expect(ScheduledJobs::DummyScheduledJob.instance.runs.first.status).to be :failed
    end

    it 'sets running dates' do
      ScheduledJobs::DummyScheduledJob.run
      job_run = ScheduledJobs::DummyScheduledJob.instance.runs.first
      expect(job_run.started_at).not_to be_nil
      expect(job_run.finished_at).not_to be_nil
    end

    it 'sets the progress to 100% at the end' do
      ScheduledJobs::DummyScheduledJob.run
      expect(ScheduledJobs::DummyScheduledJob.instance.runs.first.progress).to be 100
    end

    it 'creates log messages when logging' do
      ScheduledJobs::LoggingJob.run
      last_job_run = ScheduledJobs::LoggingJob.instance.runs.first
      expect(last_job_run.messages.size).to be 3
      expect(last_job_run.messages[2].kind).to be :debug
      expect(last_job_run.messages[2].message).to be == 'foo'
      expect(last_job_run.messages[3].kind).to be :error
      expect(last_job_run.messages[3].message).to be == 'bar'
    end

  end

end
