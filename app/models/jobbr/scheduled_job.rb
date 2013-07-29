class Jobbr::ScheduledJob < Jobbr::Job

  field :scheduled, type: Boolean, default: true

  default_scope ->{ Jobbr::Job.where(scheduled: true, :_type.ne => nil) }

  def perform
    raise NotImplementedError.new :message => 'Must be implemented'
  end

  def self.every(every = nil, options = {})
    @every = [every, options] if every
    @every
  end

  # heroku frequency can be :minutely, :hourly or :daily
  def self.heroku_run(frequency, options = {})
    @heroku_frequency = frequency
    @heroku_priority = options[:priority] || 0
  end

  def self.heroku_frequency
    @heroku_frequency
  end

  def self.heroku_priority
    @heroku_priority
  end

  def self.task_name(with_namespace = false)
    task_name = name.demodulize.underscore
    if with_namespace
      "jobbr:#{task_name}"
    else
      task_name
    end
  end

end