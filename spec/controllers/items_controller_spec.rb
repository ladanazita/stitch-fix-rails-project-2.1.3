require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:items) {FactoryGirl.create_list(:item, 4)}
  let(:item_1) {FactoryGirl.create(:item, created_at: "Mon, 03 Aug 2015 03:08:27 UTC +00:00")}
  let(:item_2) {FactoryGirl.create(:item, created_at: "Tues, 04 Aug 2015 03:08:27 UTC +00:00")}
  let(:item_3){ FactoryGirl.create(:item, created_at: "Wed, 05 Aug 2015 03:08:27 UTC +00:00")}

  describe '#index' do

    before(:each) {get :index}

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end

    it 'success' do
      expect(response).to be_success
    end

    it 'assigns all items to @items' do
      expect(assigns(:items)).to match_array items
    end

    it "orders items by created at date" do
      results = Item.order('created_at DESC')
      results == [item_1, item_2, item_3]
    end

  end

end
