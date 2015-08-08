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

  describe '#set_minimum_price' do

    let(:item){ FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: 5, type: "Pants")) }
    let(:item1){ FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: 6, type: "Dress")) }
    let(:item2){ FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: 4, type: "Top")) }

    it "should set a minimum price of $5 for Pants" do
      expect(item.price_sold).to eq(5)
    end

    it "should set a minimum price of $5 for Dresses" do
      expect(item1.price_sold).to eq(5)
    end

    it "should set a minimum price of $2 for everything else" do
      expect(item2.price_sold).to eq(2)
    end
  end

  describe ".search" do

    let(:status) {"clearanced"}
    let(:item) {FactoryGirl.create(:item, status: status, clearance_batch_id: 1)}
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
      expect{ item }.should_not_receive(:item)
    end

    before do
      Item.search(1)
    end

    it "should return results based on input" do
      expect(item.clearance_batch_id).to eq(1)
    end

    before do
      Item.search(2)
    end

    it "should return no results if none match query" do
      expect{ item }.should_not_receive(:item)
    end

  end

end
