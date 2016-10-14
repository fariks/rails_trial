class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :loads, foreign_key: true
      t.date :deliveryDate
      t.string :deliveryShift
      t.string :originName
      t.string :originRawLine1
      t.string :originCity
      t.string :originState
      t.string :originZip
      t.string :originCountry
      t.string :clientName
      t.string :destinationRawLine1
      t.string :destinationCity
      t.string :destinationState
      t.string :destinationZip
      t.string :destinationCountry
      t.string :phoneNumber
      t.string :mode
      t.integer :purchaseOrderNumber
      t.float :volume
      t.integer :handlingUnitQuantity
      t.string :handlingUnitType

      t.timestamps
    end
  end
end
