class ProductImportJob < ImportJob
  def import_processor_klass
    ::ProductImporter::FileProcessor
  end
end
