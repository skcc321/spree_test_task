require 'csv'
require 'tempfile'

class ImportStrategies::CsvImportStrategy < ImportStrategies::BaseImport_strategy
  SEPARATOR = ';'.freeze

  def extract_data
    ::CSV.foreach(input_file, col_sep: SEPARATOR, headers: true) do |row|
      yield($., row.to_s(col_sep: SEPARATOR), row.to_hash)
    end
  end

  def headers
    CSV.open(input_file, 'r', col_sep: SEPARATOR) { |csv| csv.first }
  end

  def make_error_file(errors, &block)
    file = Tempfile.new(['import', '.csv'])

    CSV.open(file.path, "wb") do |csv|
      csv << headers + ['original_file_line_number', 'errors']

      errors.each do |error|
        csv << (error[:line].split(SEPARATOR) + [error[:row_number], error[:errors]])
      end
    end

    yield(file)

  ensure
    file.close
    file.unlink
  end
end
