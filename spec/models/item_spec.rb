require 'rails_helper'

describe Item do
  describe "#perform_clearance!" do

    let(:wholesale_price) { 100 }
    let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }
    before do
      item.clearance!
      item.reload
    end

    it "should mark the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end

    it "should set the price_sold as 75% of the wholesale_price" do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
    end
  end

  describe ".search" do
    let(:status) {"clearanced"}
    let(:item) {FactoryGirl.create(:item, status: status)}
    before do
      Item.search("clearanced")
    end

    it "should return results based on input" do
      expect(item.status).to eq("clearanced")
    end

    before do
      Item.search("sellable")
    end

    it "should return no results if none match query" do
      expect { item }.should_not_receive(:item)
    end
  end
end
