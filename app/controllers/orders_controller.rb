class OrdersController < ApplicationController
  # before_action :find_user, only: [:create, :new, :express]
  before_action :find_room, only: [:create, :new, :express]
  def express
    # current_cart.build_order.price_in_cents
    response = EXPRESS_GATEWAY.setup_purchase(@room.build_order.price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url(room_id: @room.uid),
      :cancel_return_url => request.base_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def new
    @order = Order.new(:express_token => params[:token])
  end
  
  def create
    # current_cart.build_order(order_params)
    @order = @room.build_order(order_params)
    @order.ip_address = request.remote_ip
    if @order.save
      if @order.purchase
        flash.now[:notice] = 'Successfully purchased.'
        redirect_to room_path(@room.uid)
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
    params.require(:order).permit(:express_token)
  end

  def find_room
    @room = Room.find_by_uid params[:room_id]
  end
end