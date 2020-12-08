class LineItemsController < ApplicationController
  def add_line_item
    add_item = true

    @line_items = Cart.current_cart(current_user).line_items
    @line_items.each do |line_item|
      if line_item.inventory_id == params['inventory_id'].to_i
        add_item = false
        new_quantity = line_item.quantity += params['quantity'].to_i
        line_item.update!(quantity: new_quantity)
        break
      end
    end

    if add_item
      @line_item = LineItem.new(inventory_id: params['inventory_id'].to_i, quantity: params['quantity'].to_i, cart_id: params['cart_id'].to_i)
      @line_item.save
    end
  end
end
