class AddEmailColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :email, :string
  end
end
