class ProductImporter::FileProcessor < BaseFileProcessor
  def line_processor_klass
    ::ProductImporter::LineProcessor
  end
end
