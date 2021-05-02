class Admins::ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    if product_params['image'].present?
      response = Cloudinary::Uploader.upload(product_params['image'].path, :public_id => "#{@product.sku}-#{@product.color}", folder: "#{@product.sku}")
      @product.image = response['secure_url']
    end

    @product.save
    redirect_to admins_products_path
  end

  def update
    @product = Product.find(params[:id])
    if product_params['image'].present?
      response = Cloudinary::Uploader.upload(product_params['image'].path, :public_id => "#{@product.sku}-#{@product.color}", folder: "#{@product.sku}")
      params['product']['image'] = response['secure_url']
    end

    updated = Products::ProductUpdater.new(product: @product, params: params).call
    updated ? (redirect_to admins_products_path) : (render 'edit')
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to admins_products_path
  end

  private
  def product_params
    params.require(:product).permit(:sku, :color, :image)
  end

end
