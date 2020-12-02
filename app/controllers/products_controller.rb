class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @products = Product.where(sku: params[:id])
    if params[:product_id].nil?
      @selected_product = @products.first
    else
      @selected_product = Product.find(params[:product_id])
      render partial: "product_detail"
    end
  end
  
  private
    def product_params
      params.require(:product).permit(:sku, :color, :image)
    end
end
