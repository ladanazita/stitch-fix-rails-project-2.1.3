class ItemsController < ApplicationController

  def index
    if params[:search]
      @items = Item.search(params[:search]).order('created_at DESC')
    else
      @items = Item.order('created_at DESC')
    end
  end

end
