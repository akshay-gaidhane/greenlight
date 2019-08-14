class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.datetime :purchased_at
      t.timestamps
    end
  end
end
