require "rails_helper"

RSpec.describe ProductImporter::FileProcessor do
  let(:valid_input_file_path) { Rails.root.join('spec', 'support', 'files', 'sample.csv') }
  let(:invalid_input_file_path) { Rails.root.join('spec', 'support', 'files', 'invalid_sample.csv') }
  let(:invalid_ext_input_file_path) { Rails.root.join('spec', 'support', 'files', 'invalid_ext_sample.txt') }
  let(:invalid_row_input_file_path) { Rails.root.join('spec', 'support', 'files', 'invalid_row_sample.csv') }

  before do
    Spree::ShippingCategory.create(name: 'Default')
  end

  context 'with valid input file' do
    subject { described_class.new(valid_input_file_path) }

    describe '#perform' do
      it 'return true' do
        expect(subject.perform).to be_truthy
      end

      it 'creates some Products' do
        expect do
          subject.perform
        end.to change { Spree::Product.count }.by(3)
      end

      it 'sets proper status' do
        subject.perform
        expect(subject.status).to eq(described_class::SUCCESS_STATUS)
      end
    end
  end

  context 'with invalid ext input file' do
    subject { described_class.new(invalid_ext_input_file_path) }

    describe '#perform' do
      it 'return true' do
        expect(subject.perform).to be_falsy
      end

      it 'creates some Products' do
        expect do
          subject.perform
        end.to change { Spree::Product.count }.by(0)
      end

      it 'sets proper status' do
        subject.perform
        expect(subject.status).to eq(described_class::WRONG_EXT_STATUS)
      end
    end
  end

  context 'with invalid input file' do
    subject { described_class.new(invalid_ext_input_file_path) }

    describe '#perform' do
      it 'return true' do
        expect(subject.perform).to be_falsy
      end

      it 'creates some Products' do
        expect do
          subject.perform
        end.to change { Spree::Product.count }.by(0)
      end

      it 'sets proper status' do
        subject.perform
        expect(subject.status).to eq(described_class::WRONG_FILE_STATUS)
      end
    end
  end

  context 'with input file with error lines' do
    subject { described_class.new(invalid_row_input_file_path) }

    describe '#perform' do
      it 'return true' do
        expect(subject.perform).to be_falsy
      end

      it 'creates some Products' do
        expect do
          subject.perform
        end.to change { Spree::Product.count }.by(3)
      end

      it 'sets proper status' do
        subject.perform
        expect(subject.status).to eq(described_class::ERROR_LINES_STATUS)
      end

      it 'fills error_rows with proper messages' do
        subject.perform
        expect(subject.error_rows).to eq([
          {
            row_number: 5,
            line: ";;;;aoeuaoeu;;;\n",
            errors: [
              "Must supply price for variant or master.price for product."
            ]
          }
        ])
      end
    end
  end
end
