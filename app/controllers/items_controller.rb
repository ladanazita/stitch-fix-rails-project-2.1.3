class ItemsController < ApplicationController

  def index
    if params[:search]
      @items = Item.search(params[:search]).order('created_at DESC')
    else
      @items = Item.order('created_at DESC')
    end
    @items = @items.paginate(:page => params[:page], :per_page => 20)
  end

end
