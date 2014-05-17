$:.push File.expand_path("../lib", __FILE__)

require "jobbr/version"

Gem::Specification.new do |s|
  s.name        = "jobbr"
  s.version     = Jobbr::VERSION
  s.authors     = ["Christian Blavier"]
  s.email       = ["cblavier@gmail.com"]
  s.homepage    = "https://github.com/cblavier/jobbr"
  s.summary     = "Rails supervision UI for your Cron jobs and your Delayed Jobs."
  s.description = "Jobbr provideds a convenient framework and UI to make your Cron jobs and Scheduled Jobs more manageable."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rails', '>= 4.0.0'

  # UI
  s.add_runtime_dependency 'jquery-rails'
  s.add_runtime_dependency 'whenever'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'chronic_duration'
  s.add_runtime_dependency 'sass-rails'
  s.add_runtime_dependency 'coffee-rails'

  # Backend
  s.add_runtime_dependency 'redis'
  s.add_runtime_dependency 'ohm'
  s.add_runtime_dependency 'ohm-contrib'
  s.add_runtime_dependency 'sidekiq'
  s.add_runtime_dependency 'sidekiq-delay'

end
