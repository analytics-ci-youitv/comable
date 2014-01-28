module Comable::ActsAsComableCustomer
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_comable_customer
        has_many :comable_orders, class_name: 'Comable::Order'
        alias_method :orders, :comable_orders
        include InstanceMethods
      end
    end

    module InstanceMethods
      def initialize(attributes={})
        super
        alias_methods_to_comable_customer_accsesor
      end

      def add_cart_item(obj)
        case obj
        when Comable::Engine::config.product_table.to_s.classify.constantize
          add_product_to_cart(obj)
        when Array
          obj.map {|product| add_product_to_cart(product) }
        else
          raise
        end
      end

      def remove_cart_item(obj)
        case obj
        when Comable::Engine::config.product_table.to_s.classify.constantize
          remove_product_from_cart(obj)
        else
          raise
        end
      end

      def cart_items
        customer_id = "#{Comable::Engine::config.customer_table.to_s.singularize}_id"
        Comable::CartItem.where(customer_id => self.id)
      end

      def cart
        Cart.new(cart_items)
      end

      class Cart < Array
        def price
          self.sum(&:price)
        end
      end

      def order
        self.orders.create
      end

      private

      def add_product_to_cart(product)
        cart_items = find_cart_items_by(product)
        if cart_items.any?
          cart_item = cart_items.first
          cart_item.update_attributes(quantity: cart_item.quantity.next)
        else
          cart_items.create
        end
      end

      def remove_product_from_cart(product)
        cart_item = find_cart_items_by(product).first
        return false unless cart_item

        cart_item.quantity = cart_item.quantity.pred
        if cart_item.quantity.nonzero?
          cart_item.save
        else
          cart_item.destroy
        end
      end

      def find_cart_items_by(product)
        raise unless product.is_a?(Comable::Engine::config.product_table.to_s.classify.constantize)

        customer_id = "#{Comable::Engine::config.customer_table.to_s.singularize}_id"
        product_id = "#{Comable::Engine::config.product_table.to_s.singularize}_id"

        Comable::CartItem.where(customer_id => self.id, product_id => product.id)
      end

      def alias_methods_to_comable_customer_accsesor
        config = Comable::Engine::config
        return unless config.respond_to?(:customer_columns)

        config.customer_columns.each_pair do |column_name,actual_column_name|
          next if actual_column_name.blank?
          next if actual_column_name == column_name

          class_eval do
            alias_attribute column_name, actual_column_name
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Comable::ActsAsComableCustomer::Base
