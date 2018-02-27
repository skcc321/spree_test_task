require "rails_helper"

RSpec.describe ProductImportJob, type: :model do
  it 'has valid factory' do
    expect(build(:product_import_job)).to be_valid
  end

  before do
    Spree::ShippingCategory.create(name: 'Default')
  end

  describe '#perform' do
    let(:product_import_job) { create(:product_import_job) }

    it 'creates products' do
      expect do
        product_import_job.perform
      end.to change { Spree::Product.count }.by(3)
    end
  end
end
