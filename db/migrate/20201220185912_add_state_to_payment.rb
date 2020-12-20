class AddStateToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :state, :string
  end
end
