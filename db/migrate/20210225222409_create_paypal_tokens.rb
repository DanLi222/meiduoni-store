class CreatePaypalTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :paypal_tokens do |t|
      t.string :access_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
