class ImportWorker
  include Sidekiq::Worker

  def perform(import_job_id)
    import_job = ImportJob.find(import_job_id)
    import_job.perform
  end
end
