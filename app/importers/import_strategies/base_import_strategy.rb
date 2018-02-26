class ImportStrategies::BaseImport_strategy
  attr_reader :input_file

  def initialize(input_file)
    @input_file = input_file
  end

  def extract_data
    raise(NotImplementedError)
  end
end
