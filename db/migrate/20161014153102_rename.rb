class Rename < ActiveRecord::Migration[5.0]
  def change
    rename_column :loads, :deliveryDate, :delivery_date
    rename_column :loads, :deliveryShift, :delivery_shift
  end
end
