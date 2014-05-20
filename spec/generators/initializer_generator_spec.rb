require 'spec_helper'

describe Jobbr::InitializerGenerator, type: :generator do

  before do
    run_generator
  end

  it 'creates jobbr initializer file' do
    assert_file 'config/initializers/jobbr.rb'
  end

end
