class ShopsController < ApplicationController

  def new
    @shop_owner = ShopOwner.find(params[:shop_owner_id])
  end

  def create
    @shop_owner = ShopOwner.find(params[:shop_owner_id])
    @shop = @shop_owner.create_shop(shop_params)
    if @shop
      redirect_to dashboard_path(@shop_owner), notice: "Shop Creation Successful"
    else
      flash["errors"] = @shop.errors.full_messages
      flash["user"] = @shop_owner
      redirect_to :back
    end
  end

  def show
    @shop_owner = ShopOwner.find(params[:shop_owner_id])
    @shop = @shop_owner.shop
  end

  def destroy
  end


  private

  def shop_params
    params.permit(:name, :url, :description, :address, :city, :state, :country, :phone, :shop_owner_id)
  end

end
