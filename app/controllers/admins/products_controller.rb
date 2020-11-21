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
    response = Cloudinary::Uploader.upload(product_params['image'].path,:public_id => "#{@product.sku}-#{@product.color}")
    @product.image = response['secure_url']
    @product.save
    redirect_to products_path
  end

  def update
    @product = Product.find(params[:id])
    response = Cloudinary::Uploader.upload(product_params['image'].path,:public_id => "#{@product.sku}-#{@product.color}")
    params['product']['image'] = response['secure_url']
    if @product.update(product_params)
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path
  end

  private
  def product_params
    params.require(:product).permit(:sku, :color, :image)
  end

end
