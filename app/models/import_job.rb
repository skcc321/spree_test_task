class ImportJob < ApplicationRecord
  include AASM

  # State machine
  aasm column: :state do
    state :new, initial: true
    state :running, :done, :failed

    event :run do
      transitions from: :new, to: :running
    end

    event :finish do
      transitions from: :running, to: :done
    end

    event :fail do
      transitions from: :running, to: :failed
    end
  end

  # Files
  mount_uploader :input_file, DocumentUploader
  mount_uploader :errors_file, DocumentUploader

  validates :input_file, presence: true

  # Template
  def import_processor_klass
    raise(NotImplementedError)
  end

  def perform
    self.run!

    import_processor = import_processor_klass.new(input_file.current_path)

    if import_processor.perform
      self.finish!

      return true
    else
      import_processor.errors_file do |f|
        self.errors_file = f
        self.fail!
      end

      return false
    end
  end

  def perform_async
    ::ImportingJob.perform_later(self.id)
  end
end
