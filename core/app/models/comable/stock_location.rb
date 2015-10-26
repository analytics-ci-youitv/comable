module Comable
  class StockLocation < ActiveRecord::Base
    has_many :shipments, class_name: Comable::Shipment.name
    has_many :stocks, class_name: Comable::Stock.name, dependent: :destroy
    belongs_to :address, class_name: Comable::Address.name

    validates :name, presence: true, length: { maximum: 255 }
  end
end
