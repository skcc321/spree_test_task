require 'csv'

class ImportStrategies::CsvImportStrategy < ImportStrategies::BaseImport_strategy
  SEPARATOR = ';'.freeze

  def extract_data
    ::CSV.foreach(input_file, col_sep: SEPARATOR, headers: true) do |row|
      yield(row.to_s(col_sep: SEPARATOR), row.to_hash)
    end
  end

  def headers
    CSV.open(input_file, 'r', col_sep: SEPARATOR) { |csv| csv.first }
  end
end
