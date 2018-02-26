class ProductImporter::LineProcessor < BaseLineProcessor
  attr_reader :line

  NAME = 'name'.freeze
  DESCRIPTION = 'description'.freeze
  PRICE = 'price'.freeze
  AVAILABILITY_DATE = "availability_date".freeze
  SLUG = "slug".freeze
  STOCK_TOTAL = "stock_total".freeze
  CATEGORY = "category".freeze

  def initialize(line)
    @line = line
  end

  def self.headers
    [
      nil,
      NAME,
      DESCRIPTION,
      PRICE,
      AVAILABILITY_DATE,
      SLUG,
      STOCK_TOTAL,
      CATEGORY
    ]
  end

  def perform
    # save records to DB
    line[NAME]
    line[DESCRIPTION]
  end
end
