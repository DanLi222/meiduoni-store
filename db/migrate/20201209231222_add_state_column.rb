class AddStateColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :state, :string
  end
end
