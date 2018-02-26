class ImportJob < ApplicationRecord
  include AASM

  # State machine
  aasm do
    state :new, initial: true
    state :running, :done, :failed

    event :run do
      transitions from: :new, to: :running
    end

    event :finish do
      transitions running: :done
    end

    event :fail do
      transitions running: :failed
    end
  end

  # Uploaders
  mount_uploader :input_file, DocumentUploader
  mount_uploader :errors_file, DocumentUploader

  # Template
  def import_processor_klass
    raise(NotImplementedError)
  end

  def perform
    self.running!

    import_processor = import_processor_klass.new(input_file)
    import_processor.perform

    if import_processor.success?
      self.finish!

      return true
    else
      self.errors_file = import_processor.errors_file
      self.fail!

      return false
    end
  end

  def perform_async
    ImportWorker.perform_async(self.id)
  end
end
