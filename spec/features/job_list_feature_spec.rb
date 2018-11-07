# encoding: utf-8
require 'spec_helper'

feature 'Job list' do

  before do
    Timecop.travel(2.hours.ago)
    ScheduledJobs::DummyJob.run
    ScheduledJobs::LoggingJob.run
    DelayedJobs::DummyJob.run
    DelayedJobs::OtherDummyJob.run
    Timecop.return
  end

  it 'shows all scheduled jobs' do
    visit jobbr_path
    assert_title 'Job list'
    expect(find('.table.scheduled-jobs tbody')).to have_selector('tr', count: 2)
  end

  it 'shows all delayed jobs' do
    visit jobbr_path
    assert_title 'Job list'
    expect(find('.table.delayed-jobs tbody')).to have_selector('tr', count: 2)
  end

  it 'shows correct status for each job' do
    Jobbr::Run.create(status: :failed,  started_at: Time.now, job: ScheduledJobs::DummyJob.instance)
    visit jobbr_path
    assert_title 'Job list'
    expect(first('.table.scheduled-jobs tbody tr')).to have_selector('i.failed')
  end

  it 'show all runs for a specific job' do
    Timecop.travel(5.minutes.ago)
    Jobbr::Run.create(status: :failed,  started_at: Time.now, job: ScheduledJobs::DummyJob.instance)
    Timecop.return
    Jobbr::Run.create(status: :running, started_at: Time.now, job: ScheduledJobs::DummyJob.instance)

    visit jobbr_path
    assert_title 'Job list'

    first('.scheduled-jobs a.all-runs').click
    assert_title 'Dummy job'
    expect(find('.table tbody')).to have_selector('tr', count: 3)
  end

  it 'shows a specific run' do
    visit jobbr_path
    assert_title 'Job list'

    first('.scheduled-jobs a.last-run').click
    assert_title I18n.localize(ScheduledJobs::DummyJob.instance.ordered_runs.first.started_at)
  end

  def assert_title(title)
    expect(find('ol.breadcrumb li.active')).to have_content(title)
  end

end
