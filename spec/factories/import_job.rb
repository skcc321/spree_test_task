FactoryBot.define do
  factory :import_job do

    factory :product_import_job, class: ProductImportJob do
      input_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'sample.csv')) }
    end
  end
end
