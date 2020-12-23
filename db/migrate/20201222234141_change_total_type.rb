class ChangeTotalType < ActiveRecord::Migration[6.0]
  def change
    change_column :carts, :total, :decimal, precision: 9, scale: 2
  end
end
