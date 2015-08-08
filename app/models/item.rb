class Item < ActiveRecord::Base

  validate :set_minimum_price

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    update_attributes!(status: 'clearanced',
                       price_sold: style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE)
  end

  # returns the items whose status contain one or more words that form the search
  def self.search(search)
    # where(:status, search) -> This would return an exact match of the search
    where("status like ? OR clearance_batch_id like ?", "%#{search}%", "%#{search}%" )
  end

private
  def set_minimum_price
    #min should be $5 for dresses and pants
    if style.type === "Dress" || style.type === "Pants" and self.price_sold < 5
      self.update(price_sold: 5)
    #everything else min price $2
    elsif self.price_sold < 2
      self.update(price_sold: 2)
    end

  end
end
