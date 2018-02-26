class ProductImportJob < ImportJob
  def import_processor_klass
    ProductsImporter::FileProcessor
  end
end
