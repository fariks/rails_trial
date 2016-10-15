class LoadValidator < ActiveModel::Validator
  def validate(load)
    prev_load = nil
    next_load = nil
    case Load.delivery_shifts[load.delivery_shift]
      when Load.delivery_shifts[:M]
        prev_load = Load.where('delivery_date = ? and delivery_shift = ?', load.delivery_date - 1.day, Load.delivery_shifts[:E]).first
        next_load = Load.where('delivery_date = ? and delivery_shift = ?', load.delivery_date, Load.delivery_shifts[:N]).first
      when Load.delivery_shifts[:N]
        prev_load = Load.where('delivery_date = ? and delivery_shift = ?', load.delivery_date, Load.delivery_shifts[:M]).first
        next_load = Load.where('delivery_date = ? and delivery_shift = ?', load.delivery_date, Load.delivery_shifts[:E]).first
      when Load.delivery_shifts[:E]
        prev_load = Load.where('delivery_date = ? and delivery_shift = ?', load.delivery_date, Load.delivery_shifts[:N]).first
        next_load = Load.where('delivery_date = ? and delivery_shift = ?', load.delivery_date + 1.day, Load.delivery_shifts[:M]).first
    end
    if !prev_load.nil? and (prev_load.user.id == load.user.id)
      load.errors.add(:load, "Driver already has assigned load for previous delivery shift. Please choose another driver.")
    end
    if !next_load.nil? and (next_load.user.id == load.user.id)
      load.errors.add(:load, "Driver already has assigned load for next delivery shift. Please choose another driver.")
    end
  end
end

class Load < ApplicationRecord
  validates_uniqueness_of :delivery_date, :scope => :delivery_shift
  include ActiveModel::Validations
  validates_with LoadValidator

  resourcify
  belongs_to :user
  has_many :orders, dependent: :nullify

  enum delivery_shift: [ :M, :N, :E ]
end


