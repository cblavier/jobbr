require 'spec_helper'

module Jobbr

  describe DelayedJob do

    it 'creates a new job by its name' do
      expect {
        DelayedJob.run_delayed_by_name('jobbr/test_delayed_job', {}, false)
      }.to change{ TestDelayedJob.count }.by(1)
    end

    it 'does not create duplicated name jobs' do
      expect {
        DelayedJob.run_delayed_by_name('jobbr/test_delayed_job', {}, false)
        DelayedJob.run_delayed_by_name('jobbr/test_delayed_job', {}, false)
        DelayedJob.run_delayed_by_name('jobbr/test_delayed_job', {}, false)
      }.to change{ DelayedJob.count }.by(1)
      expect {
        DelayedJob.run_delayed_by_name('jobbr/other_test_delayed_job', {}, false)
        DelayedJob.run_delayed_by_name('jobbr/other_test_delayed_job', {}, false)
      }.to change{ DelayedJob.count }.by(1)
    end

    class TestDelayedJob < DelayedJob
      def perform(params = {}, run)
      end
    end

    class OtherTestDelayedJob < DelayedJob
      def perform(params = {}, run)
      end
    end

  end

end