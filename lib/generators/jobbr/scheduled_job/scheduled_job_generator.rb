class Jobbr::ScheduledJobGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def create_scheduled_job
    empty_directory "app/models/scheduled_jobs"
    template "scheduled_job.erb", "app/models/scheduled_jobs/#{file_name}_job.rb", name: file_name
    generate 'jobbr:scheduled_job_config'
  end

end
