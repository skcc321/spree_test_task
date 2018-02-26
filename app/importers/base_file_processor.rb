class BaseFileProcessor
  CSV_EXT = '.csv'.freeze

  attr_reader :input_file,
    :error_rows

  def initialize(input_file)
    @input_file = input_file
    @error_rows = []
  end

  def perform
    raise(NotImplementedError)
  end

  def prepare_data
    import_strategy.new(input_file)
  end

  def import_strategy
    case File.extname(input_file)
    when CSV_EXT then ImportStrategies::CsvStrategy
    else
      raise('unknows strategy')
    end
  end

  def success?
    error_rows.empty?
  end
end
