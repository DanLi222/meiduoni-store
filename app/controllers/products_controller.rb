class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @selected_product = selected_product
    @products = products
    @inventories = inventories
    @backodered_inventory_ids = backodered_inventory_ids
    @cart_id = current_user&.cart_ids&.last

    render partial: "product_detail" unless params[:product_id].nil?
  end
  
  private
    def product_params
      params.require(:product).permit(:sku, :color, :image)
    end

    def products
      Product.where(sku: @selected_product.sku).pluck :color, :id
    end

    def selected_product
      params[:product_id].nil? ? Product.find(params[:id]) : Product.find(params[:product_id])
    end

    def inventories
      @selected_product.inventories.pluck(:size, :quantity, :id)
    end

    def backodered_inventory_ids
      @selected_product.inventories.backordered.pluck :id
    end
end
