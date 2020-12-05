class ChangeQuantityToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :line_items, :quantity, :integer
  end
end
