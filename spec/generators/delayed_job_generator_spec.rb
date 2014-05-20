require 'spec_helper'

describe Jobbr::DelayedJobGenerator, type: :generator do

  arguments %w(foo)

  it 'creates job model' do
    run_generator
    assert_file 'app/models/delayed_jobs/foo_job.rb'
  end

end
