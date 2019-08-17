class AddRoomIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :room_id, :integer
  end
end
