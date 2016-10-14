class ChangeColumnTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :deliveryShift
    add_column :orders, :deliveryShift, :integer
    remove_column :orders, :mode
    add_column :orders, :mode, :integer
    remove_column :orders, :handlingUnitQuantity
    add_column :orders, :handlingUnitQuantity, :integer
    remove_column :orders, :handlingUnitType
    add_column :orders, :handlingUnitType, :integer

    remove_column :loads, :deliveryShift
    add_column :loads, :deliveryShift, :integer
  end
end
