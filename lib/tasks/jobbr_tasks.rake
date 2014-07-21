namespace :jobbr do

  desc 'Mark all running job as failed.'
  task :sweep_running_jobs => :environment do

    Jobbr::Run.find(status: :running).union(status: :waiting).each do |run|
      run.status = :failed
      run.save
    end
    
  end

end
