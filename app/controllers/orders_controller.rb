class OrdersController < ApplicationController
  before_action :set_orders
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET loads/1/orders
  def index
    @orders = @load.orders
  end

  # GET loads/1/orders/1
  def show
  end

  # GET loads/1/orders/new
  def new
    @order = @load.orders.build
  end

  # GET loads/1/orders/1/edit
  def edit
  end

  # POST loads/1/orders
  def create
    @order = @load.orders.build(order_params)

    if @order.save
      redirect_to([@order.load, @order], notice: 'Order was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT loads/1/orders/1
  def update
    if @order.update_attributes(order_params)
      redirect_to([@order.load, @order], notice: 'Order was successfully updated.')
    else
      render action: 'edit'
    end
  end

  # DELETE loads/1/orders/1
  def destroy
    @order.destroy

    redirect_to load_orders_url(@load)
  end

  def unassign
    @order = @load.orders.find(params[:order_id])
    @order.update_attributes({load_id: nil})

    redirect_to load_edit_orders_path(@load)
  end

  def assign
    @order = Order.find(params[:order_id])

    #validation
    assigned_volume = @load.orders.sum(:volume)
    if @order.volume + assigned_volume > 1400
      redirect_to load_edit_orders_path(@load), notice: 'Cannot assign order. Vehicle already full'
    else
      @order.update_attributes({load: @load})
      redirect_to load_edit_orders_path(@load)
    end
  end

  def update_delivery_order
    @order = Order.find(params[:id])
    @order.delivery_order_position = params[:delivery_order_position]
    @order.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orders
      @load = Load.find(params[:load_id])
    end

    def set_order
      @order = @load.orders.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:deliveryDate, :deliveryShift, :originName, :originRawLine1, :originCity, :originState, :originZip, :originCountry, :clientName, :destinationRawLine1, :destinationCity, :destinationState, :destinationZip, :destinationCountry, :phoneNumber, :mode, :purchaseOrderNumber, :volume, :handlingUnitQuantity, :handlingUnitType, :delivery_order_position)
    end
end
