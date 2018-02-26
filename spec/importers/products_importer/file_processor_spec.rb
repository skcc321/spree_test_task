require "rails_helper"

RSpec.describe ProductImporter::FileProcessor do
  let(:valid_input_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'sample.csv')) }
  let(:invalid_input_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'invalid_sample.csv')) }
  let(:invalid_ext_input_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'invalid_ext_sample.csv')) }


  context 'with valid input file' do
    subject { described_class.new(valid_input_file) }

    describe '#perform' do
      it 'does not rise an error' do
        expect(subject.perform).not to_rise_error
      end
    end
  end
end
