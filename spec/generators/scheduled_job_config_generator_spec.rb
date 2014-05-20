require 'spec_helper'

describe Jobbr::ScheduledJobConfigGenerator, type: :generator do

  it 'creates job model' do
    run_generator
    assert_file 'config/schedule.rb'
  end

end
