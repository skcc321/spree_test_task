class BaseFileProcessor
  CSV_EXT = '.csv'.freeze

  SUCCESS_STATUS = 'success_status'.freeze
  WRONG_EXT_STATUS = 'wrong_ext_status'.freeze
  WRONG_FILE_STATUS = 'wrong_ext_status'.freeze
  ERROR_LINES_STATUS = 'error_lines_status'.freeze

  attr_reader :input_file,
    :error_rows,
    :status

  def initialize(input_file)
    @input_file = input_file
    @error_rows = []
    @status = SUCCESS_STATUS
  end

  def perform
    # select import strategy
    if import_strategy_klass.present?
      import_strategy = import_strategy_klass.new(input_file)
    else
      set_status(WRONG_EXT_STATUS)
      return false
    end

    # headers mismatch
    unless line_processor_klass.headers == import_strategy.headers
      set_status(WRONG_FILE_STATUS)
      return false
    end

    # go over lines
    import_strategy.extract_data do |row_number, original_row, parced_row|
      line_processor = line_processor_klass.new(parced_row)

      # line is invalid
      unless line_processor.perform
        add_error_line({
          row_number: row_number,
          line: original_row,
          errors: line_processor.errors
        })
      end
    end

    # change status if row with error exists
    if error_rows.any?
      set_status(ERROR_LINES_STATUS)
    end

    status == SUCCESS_STATUS
  end

  def line_processor_klass
    raise(NotImplementedError)
  end

  def import_strategy_klass
    case File.extname(input_file)
    when CSV_EXT then ImportStrategies::CsvImportStrategy
    end
  end

  def add_error_line(row)
    @error_rows << row
  end

  def errors_file(&block)
    import_strategy_klass.new(input_file).make_error_file(error_rows, &block)
  end

  def set_status(state)
    @status = state
  end
end
