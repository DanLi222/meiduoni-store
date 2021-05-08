class LineItemsController < ApplicationController
  before_action :new_cart

  def add_to_cart
    @line_items = Cart.current_cart(current_user).line_items
    inventory_id = params['inventory_id'].to_i

    line_item = @line_items.filter { |line_item| line_item.inventory_id == inventory_id }.first

    if line_item.nil?
      add_item
    else
      update_item(line_item)
    end
    render json: { line_items_count: @line_items.count }
  end

  def remove_from_cart
    line_item_id = params['line_item_id']
    line_item = LineItem.find_by(id: line_item_id, cart_id: Cart.current_cart(current_user).id)
    line_item.destroy unless line_item.nil?
  end

  private

  def update_item(line_item)
    new_quantity = line_item.quantity + params['quantity'].to_i
    line_item.update!(quantity: new_quantity)
  end

  def add_item
    @line_item = LineItem.new(line_item_params)
    @line_item.save
  end

  def line_item_params
    params.permit(:inventory_id, :quantity, :cart_id)
  end
end
