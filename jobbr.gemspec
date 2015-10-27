$:.push File.expand_path('../lib', __FILE__)

require 'jobbr/version'

Gem::Specification.new do |s|

  s.name        = 'jobbr'
  s.version     = Jobbr::VERSION
  s.authors     = ['Christian Blavier']
  s.email       = ['cblavier@gmail.com']
  s.homepage    = 'https://github.com/cblavier/jobbr'
  s.summary     = 'Rails engine to manage jobs.'
  s.description = 'Rails engine to manage and supervise your batch jobs. Based on sidekiq.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rails', '>= 4.0.0'

  # UI
  s.add_runtime_dependency 'jquery-rails'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'chronic_duration'
  s.add_runtime_dependency 'sass-rails', '>= 4.0.2'
  s.add_runtime_dependency 'coffee-rails'
  s.add_runtime_dependency 'therubyracer'
  s.add_runtime_dependency 'less-rails'
  s.add_runtime_dependency 'bootstrap-sass'
  s.add_runtime_dependency 'font-awesome-rails'
  s.add_runtime_dependency 'kaminari'

  # Backend
  s.add_runtime_dependency 'redis'
  s.add_runtime_dependency 'ohm', '>= 2.0.1'
  s.add_runtime_dependency 'ohm-contrib'
  s.add_runtime_dependency 'sidekiq', '>= 3.0.0'
  s.add_runtime_dependency 'whenever'
  s.add_runtime_dependency 'require_all'

end
