class CreateLoads < ActiveRecord::Migration[5.0]
  def change
    create_table :loads do |t|
      t.date :deliveryDate
      t.string :deliveryShift
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
