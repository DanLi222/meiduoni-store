class AddReferenceToPayment < ActiveRecord::Migration[6.0]
  def change
    add_reference :payments, :cart, foreign_key: true
  end
end
