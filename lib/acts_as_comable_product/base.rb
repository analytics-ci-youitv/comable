module Comable::ActsAsComableProduct
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_comable_product
        Comable.const_set(:Product, self)

        has_many Comable::Stock.model_name.plural.to_sym

        after_initialize :alias_methods_to_comable_product_accsesor
        after_create :create_stock

        include InstanceMethods
      end
    end

    module InstanceMethods
      def has_stocks?
        self.stocks.activated.unsold.exists?
      end

      private

      def create_stock
        stocks = self.stocks.where(code: self.code).limit(1)
        stocks.create if stocks.empty?
      end

      def alias_methods_to_comable_product_accsesor
        config = Comable::Engine::config
        return unless config.respond_to?(:product_columns)

        config.product_columns.each_pair do |column_name,actual_column_name|
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

ActiveRecord::Base.send :include, Comable::ActsAsComableProduct::Base
