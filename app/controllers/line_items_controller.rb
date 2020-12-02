class LineItemsController < ApplicationController
  def add_line_item
    @line_item = LineItem.new(inventory_id: params['inventory_id'], quantity: params['quantity'], cart_id: params['cart_id'])
    @line_item.save
  end
end
