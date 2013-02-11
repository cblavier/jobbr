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

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "mongoid", "~> 3.0"
  s.add_dependency "whenever"
  s.add_dependency "chronic_duration"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'combustion', '~> 0.3.1'
end
