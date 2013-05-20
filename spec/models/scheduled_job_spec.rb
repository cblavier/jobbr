require 'spec_helper'

module Jobbr

  describe ScheduledJob do

    it 'creates a new job by its name' do
      expect {
        TestJob.run
      }.to change{ ScheduledJob.count }.by(1)
    end

    it 'does not create duplicated name jobs' do
      expect {
        TestJob.run
        TestJob.run
        TestJob.run
      }.to change{ ScheduledJob.count }.by(1)
      expect {
        OtherTestJob.run
        OtherTestJob.run
      }.to change{ ScheduledJob.count }.by(1)
    end

    it 'creates a job run for each run' do
      TestJob.run
      job = TestJob.last

      expect {
        TestJob.run
        TestJob.run
      }.to change{ job.reload.runs.length }.from(1).to(3)
      Run.count.should == 3
    end

    it 'does not create more run than max_run_per_job' do
      TestJob.run
      job = TestJob.last
      first_run = job.runs.first
      max_run_per_job = 5
      TestJob.any_instance.stubs(:max_run_per_job).returns(max_run_per_job)

      expect {
        (max_run_per_job + 3).times do
          TestJob.run
        end
      }.to change{ job.reload.runs.length }.from(1).to(max_run_per_job)
      Run.count.should == max_run_per_job

      # ensure that it removes first executions and not latest
      job.reload.runs.should_not include(first_run)
    end

    it 'changes run status from running to success' do
      TestJob.run do
        TestJob.last.runs.last.status.should be :running
      end
      TestJob.last.runs.last.status.should be :success
    end

    it 'changes run status from running to failure in case of exception' do
      TestJob.any_instance.stubs(:perform).raises('an error')
      begin
        TestJob.run
      rescue Exception
      end
      TestJob.last.runs.last.status.should be :failure
    end

    it 'sets runni#ng dates' do
      TestJob.run
      job_run = TestJob.last.runs.last
      job_run.started_at.should_not be_nil
      job_run.finished_at.should_not be_nil
    end

    it 'sets the progress to 100% at the end' do
      TestJob.run
      TestJob.last.runs.last.progress.should be 100
    end

    it 'creates log messages when logging' do
      class LoggingJob < ScheduledJob
        def perform
          Rails.logger.debug 'foo'
          Rails.logger.error 'bar'
        end
      end

      LoggingJob.run
      last_job_run = ScheduledJob.last.runs.unscoped.last
      last_job_run.should have(2).log_messages
      last_job_run.log_messages.first.kind.should be :debug
      last_job_run.log_messages.first.message.should == 'foo'
      last_job_run.log_messages.last.kind.should be :error
      last_job_run.log_messages.last.message.should == 'bar'
    end

  end

  class TestJob < ScheduledJob
    def perform
    end
  end

  class OtherTestJob < ScheduledJob
    def perform
    end
  end

end