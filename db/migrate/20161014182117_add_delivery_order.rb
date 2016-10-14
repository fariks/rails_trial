class AddDeliveryOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :delivery_order, :integer
  end
end
