class OrdersController < ApplicationController
  # before_action :find_user, only: [:create, :new, :express]
  before_action :find_room, only: [:create, :new, :express]
  def express
    response = EXPRESS_GATEWAY.setup_purchase(@room.orders.new.price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url(room_id: @room.uid, order_type: params[:order_type]),
      :cancel_return_url => request.base_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def new
    @order = Order.new(:express_token => params[:token], order_type: params[:order_type])
  end
  
  def create
    @order = @room.orders.new(order_params)
    @order.ip_address = request.remote_ip
    if @order.save
      if @order.purchase
        flash.now[:notice] = 'Successfully purchased.'
        if order_params[:order_type] == "Session"
          redirect_to start_meeting_path(room_uid: @room.uid)
        else
          redirect_to room_path(@room.uid)
        end
      else
        @room.order.delete
        @room.delete
        flash.now[:notice] = 'Purchase unsuccessful. Please try again'
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end
  private
    
  def order_params
    params.require(:order).permit(:express_token, :order_type)
  end

  def find_room
    @room = Room.find_by_uid params[:room_id]
  end
end