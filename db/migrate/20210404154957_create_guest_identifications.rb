class CreateGuestIdentifications < ActiveRecord::Migration[6.0]
  def change
    create_table :guest_identifications do |t|
      t.integer :guest_id
      t.string :uuid
      t.timestamps
    end
  end
end
