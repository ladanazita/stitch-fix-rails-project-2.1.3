require 'rails_helper'

RSpec.describe ClearanceBatchesController, type: :controller do
  let(:clearance_batches) {FactoryGirl.create_list(:clearance_batch, 4)}
  let(:clearance_batch) {FactoryGirl.create(:clearance_batch, :id => 1)}
  let(:items) {FactoryGirl.create_list(:item, 4, :clearance_batch_id => @clearance_batch, :status => 'clearanced')}

  describe '#index' do

    before(:each) {get :index}

    it 'renders index template' do
      expect(response).to render_template :index
    end

    it 'success' do
      expect(response).to be_success
    end

    it 'assigns all clearance_batches to @clearance_batches' do
      expect(assigns(:clearance_batches)).to match_array clearance_batches
    end
  end

  describe '#show' do
    before(:each) {get :show, id: clearance_batch.id}
      it 'shows details of a ClearanceBatch' do
        expect(assigns(:clearance_batch)).to eq clearance_batch
      end
  end


end

