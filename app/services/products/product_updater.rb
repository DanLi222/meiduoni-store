module Products
  class ProductUpdater
    def initialize(product:, params:)
      @product = product
      @params = params
    end

    def call
      update_product
      update_inventories
      update_property
    end

    private

    attr_accessor :product, :params

    def update_product
      product.update(product_params)
    end

    def update_inventories
      product.inventories.each do |i|
        i.update(quantity: inventory_params[i.size])
      end
    end

    def update_property
      product.property.update(property_params)
    end

    def product_params
      params.require(:product).permit(:sku, :image, :color)
    end

    def inventory_params
      params.require(:product).permit("35", "36", "37", "38", "39", "40")
    end

    def property_params
      params.require(:product).permit(:gender, :material, :season, :price)
    end
  end
end