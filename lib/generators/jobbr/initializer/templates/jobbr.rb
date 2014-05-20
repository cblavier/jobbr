require 'chronic_duration'
require 'haml'

Ohm.redis = Redis::Namespace.new(:jobbr, :redis => Ohm.redis)
