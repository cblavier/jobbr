require 'spec_helper'
require 'rake'

describe 'jobbr_heroku_tasks' do

  before do
    Rake.application.rake_require 'tasks/jobbr_heroku_tasks'
    Rake::Task.define_task(:environment)
  end

  it 'runs daily jobs' do
    expect {
      Rake.application.invoke_task 'jobbr:heroku:daily'
    }.to change { Jobbr::Run.all.count }.from(0).to(1)
  end

end
