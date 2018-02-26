FactoryBot.define do
  factory :import_job do

    factory :product_import_job do
      input_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'sample.csv')) }

      trait :invalid_input_file do
        input_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'invalid_sample.csv')) }
      end

      trait :invalid_ext_input_file do
        input_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'invalid_ext_sample.csv')) }
      end
    end
  end
end
