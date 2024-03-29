class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
    @clearance_batches = @clearance_batches.paginate(:page => params[:page], :per_page => 20)
  end

  def create
    params[:csv_batch_file] ?
      clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile) :
      clearancing_status = ClearancingService.new.process_input(params[:item_number])
      clearance_batch = clearancing_status.clearance_batch
      alert_messages = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end
    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end

  def show
    @clearance_batch = ClearanceBatch.find(params[:id])
    @items = Item.where(clearance_batch_id: @clearance_batch)
  end

end
