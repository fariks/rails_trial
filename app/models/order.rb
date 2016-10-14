class Order < ApplicationRecord
  resourcify
  belongs_to :load, optional: true
  enum deliveryShift: [ :M, :N, :E ]
  enum mode: [ :TRUCKLOAD ]
  enum handlingUnitType: [ :box ]

  include RankedModel
  ranks :delivery_order
end
