module Comable
  module ActsAsComableStock
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_comable_stock
          Comable.const_set(:Stock, self)
          Comable::Stock.const_set(:Mapper, comable(:stock))

          belongs_to Comable::Product.model_name.singular.to_sym

          scope :activated, -> { where.not(product_id_num: nil) }
          scope :unsold, -> { where('quantity > ?', 0) }
          scope :soldout, -> { where('quantity <= ?', 0) }

          delegate :price, to: Comable::Product.model_name.singular.to_sym

          include InstanceMethods
        end
      end

      module InstanceMethods
        def unsold?
          return false if product_id_num.nil?
          return false if quantity.nil?
          quantity > 0
        end

        def soldout?
          !unsold?
        end

        def decrement_quantity!
          ActiveRecord::Base.transaction do
            decrement!(:quantity)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableStock::Base
