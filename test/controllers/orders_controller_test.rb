require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @loads = loads(:one)
    @order = orders(:one)
  end

  test "should get index" do
    get :index, params: { loads_id: @loads }
    assert_response :success
  end

  test "should get new" do
    get :new, params: { loads_id: @loads }
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, params: { loads_id: @loads, order: @order.attributes }
    end

    assert_redirected_to loads_order_path(@loads, Order.last)
  end

  test "should show order" do
    get :show, params: { loads_id: @loads, id: @order }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { loads_id: @loads, id: @order }
    assert_response :success
  end

  test "should update order" do
    put :update, params: { loads_id: @loads, id: @order, order: @order.attributes }
    assert_redirected_to loads_order_path(@loads, Order.last)
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, params: { loads_id: @loads, id: @order }
    end

    assert_redirected_to loads_orders_path(@loads)
  end
end
