class LoadsController < ApplicationController
  before_action :set_load, only: [:show, :edit, :update, :destroy]

  # GET /loads
  # GET /loads.json
  def index
    @loads = Load.all
  end

  # GET /loads/1
  # GET /loads/1.json
  def show
  end

  # GET /loads/new
  def new
    @load = Load.new
  end

  # GET /loads/1/edit
  def edit
  end

  # POST /loads
  # POST /loads.json
  def create
    @load = Load.new(load_params)

    respond_to do |format|
      if @load.save
        format.html { redirect_to @load, notice: 'Load was successfully created.' }
        format.json { render :show, status: :created, location: @load }
      else
        format.html { render :new }
        format.json { render json: @load.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loads/1
  # PATCH/PUT /loads/1.json
  def update
    respond_to do |format|
      if @load.update(load_params)
        format.html { redirect_to @load, notice: 'Load was successfully updated.' }
        format.json { render :show, status: :ok, location: @load }
      else
        format.html { render :edit }
        format.json { render json: @load.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loads/1
  # DELETE /loads/1.json
  def destroy
    @load.destroy
    respond_to do |format|
      format.html { redirect_to loads_url, notice: 'Load was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_orders
    @assignOrders = Order.rank(:delivery_order).where(load_id: params[:load_id])#.paginate(:page => params[:page], :per_page => 10)
    @unassignOrders = Order.where(load_id: nil)#.paginate(:page => params[:page], :per_page => 10)
    @load = Load.find(params[:load_id])
  end

  def download
    @load = Load.find(params[:load_id])
    res = StringIO.new
    res.puts "delivery_date,delivery_shift,origin_name,origin_raw_line_1,origin_city,origin_state,origin_zip,origin_country,client_name,destination_raw_line_1,destination_city,destination_state,destination_zip,destination_country,phone_number,mode,purchase_order_number,volume,handling_unit_quantity,handling_unit_type \n"
    @load.orders.sort_by{|order| order.delivery_order}.each do |order|
      res.puts "#{order.deliveryDate}, #{order.deliveryShift}, #{order.originName}, #{order.originRawLine1}, #{order.originCity}, #{order.originState}, #{order.originZip}, #{order.originCountry}, #{order.clientName}, #{order.destinationRawLine1}, #{order.destinationCity}, #{order.destinationState}, #{order.destinationZip}, #{order.destinationCountry}, #{order.phoneNumber}, #{order.mode}, #{order.purchaseOrderNumber}, #{order.volume}, #{order.handlingUnitQuantity}, #{order.handlingUnitType} \n"
    end
    send_data res.string, :filename => "#{@load.delivery_date}_#{@load.delivery_shift}.txt"
  end

  def upload_orders
    require 'csv'

    csv_text = params[ :csv_file ].tempfile.read
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      params = row.to_hash
      order = {}
      order[:originRawLine1] = params['origin_raw_line_1']
      order[:originCity] = params['origin_city']
      order[:originState] = params['origin_state']
      order[:originZip] = params['origin_zip']
      order[:originCountry] = params['origin_country']
      order[:destinationRawLine1] = params['destination_raw_line_1']
      order[:destinationCity] = params['destination_city']
      order[:destinationState] = params['destination_state']
      order[:destinationZip] = params['destination_zip']
      order[:destinationCountry] = params['destination_country']
      order[:deliveryDate] = Date.strptime(params['delivery_date'], '%m/%d/%Y') unless params['delivery_date'].nil?
      order[:deliveryShift] = Order.deliveryShifts[params['delivery_shift']]
      order[:originName] = params['origin_name']
      order[:clientName] = params['client_name']
      order[:phoneNumber] = params['phone_number']
      order[:mode] = Order.modes[params['mode']]
      order[:purchaseOrderNumber] = params['purchase_order_number']
      order[:volume] = params['volume']
      order[:handlingUnitQuantity] = params['handling_unit_quantity']
      order[:handlingUnitType] = Order.handlingUnitTypes[params['handling_unit_type']]
      Order.create(order)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_load
      @load = Load.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def load_params
      params.require(:load).permit(:delivery_date, :delivery_shift, :user_id)
    end
end
