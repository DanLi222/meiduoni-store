class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @products = Product.where(sku: params[:id])
    @disabled_inventories = []
    if params[:product_id].nil?
      @selected_product = @products.first
      @inventory_array = @selected_product.inventories.map { |inventory| [inventory.size, inventory.id, inventory.quantity]}
      @disabled_inventories = disabled_inventories(@inventory_array)
    else
      @selected_product = Product.find(params[:product_id])
      @inventory_array = @selected_product.inventories.map { |inventory| [inventory.size, inventory.id, inventory.quantity]}
      @disabled_inventories = disabled_inventories(@inventory_array)
      render partial: "product_detail"
    end

  end
  
  private
    def product_params
      params.require(:product).permit(:sku, :color, :image)
    end

    def disabled_inventories(inventory_array)
      disabled_inventories = []
      inventory_array.each do |inventory|
        if inventory[2] == 0
          disabled_inventories << inventory
        end
      end
      disabled_inventories
    end
end
