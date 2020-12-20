class AddPaymentToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :payment_id, :integer
  end
end
