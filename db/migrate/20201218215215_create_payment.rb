class CreatePayment < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :provider
      t.string :payer_id
      t.string :payment_id
      t.string :token

      t.timestamps
    end
  end
end
