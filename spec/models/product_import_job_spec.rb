require "rails_helper"

RSpec.describe ProductImportJob, type: :model do
  it 'has valid factory' do
    expect(build(:product_import_job)).to be_valid
  end
end
