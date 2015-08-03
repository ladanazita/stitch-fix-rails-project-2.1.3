class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    update_attributes!(status: 'clearanced',
                       price_sold: style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE)
  end

  # It returns the items whose status contain one or more words that form the search
  def self.search(search)
    # where(:status, search) -> This would return an exact match of the search
    where("status like ?", "%#{search}%")
  end

end
