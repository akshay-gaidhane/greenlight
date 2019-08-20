class AddOrderTypeInOrders < ActiveRecord::Migration[5.2]
  def change
  	add_column :orders, :order_type, :string
  end
end
