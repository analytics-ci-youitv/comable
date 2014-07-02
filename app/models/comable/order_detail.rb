module Comable
  class OrderDetail < ActiveRecord::Base
    belongs_to Comable::Stock.model_name.singular.to_sym
    belongs_to :comable_order_deliveries, class_name: 'Comable::OrderDelivery'

    after_create :decrement_stock

    def product
      stock = send(Comable::Stock.model_name.singular)
      # TODO: if stock.comable_stock_flag
      stock.product.tap { |obj| obj.comable_product }
    end

    private

    def decrement_stock
      stock = send(Comable::Stock.model_name.singular)
      stock.decrement_quantity!
    end
  end
end
