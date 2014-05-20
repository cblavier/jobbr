class Jobbr::DelayedJobGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def create_delayed_job
    empty_directory "app/models/delayed_jobs"
    template "delayed_job.erb", "app/models/delayed_jobs/#{file_name}_job.rb", name: file_name
    generate 'jobbr:initializer' unless Rails.env.test?
  end

end
