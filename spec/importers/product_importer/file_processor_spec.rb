require "rails_helper"

RSpec.describe ProductImporter::FileProcessor do
  let(:valid_input_file_path) { Rails.root.join('spec', 'support', 'files', 'sample.csv') }
  let(:invalid_input_file_path) { Rails.root.join('spec', 'support', 'files', 'invalid_sample.csv') }
  let(:invalid_ext_input_file_path) { Rails.root.join('spec', 'support', 'files', 'invalid_ext_sample.csv') }


  context 'with valid input file' do
    subject { described_class.new(valid_input_file_path) }

    describe '#perform' do
      it 'return true' do
        binding.pry
        expect(subject.perform).to be_truthy
      end
    end
  end
end
