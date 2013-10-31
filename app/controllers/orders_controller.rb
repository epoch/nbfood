class OrdersController < ApplicationController
  before_filter :check_if_logged_in

  def new
    @meals = Meal.where(:id => params[:id])
    @order = Order.new
  end

  def create
    @meal = Meal.find(params[:id])
    @order = Order.new params[:order]
    @order.status = "requested"
    @order.user = @auth
    @auth.orders << @order
    @meal.orders << @order
    redirect_to orders_path
  end

  def index
    @orders_requested = Order.where(:status => "requested", :user_id => @auth.id)
    @orders_completed = Order.where(:status => "completed", :user_id => @auth.id)
    @orders_cancelled = Order.where(:status => "cancelled", :user_id => @auth.id)
  end

  def edit
    @order = Order.find(params[:id])
  end

  private

  def check_if_logged_in
    redirect_to new_user_path unless @auth.present?
    flash[:notice] = "Almost there, you just need to sign up now or login if you already have an account" unless @auth.present?
  end

end
