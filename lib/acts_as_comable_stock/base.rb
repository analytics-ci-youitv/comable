module Comable::ActsAsComableStock
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_comable_stock
        Comable.const_set(:Stock, self)

        belongs_to Comable::Product.model_name.singular.to_sym

        after_initialize :alias_methods_to_comable_stock_accsesor

        scope :activated, -> { where.not(product_id_num: nil) }
        scope :unsold, -> { where('quantity > ?', 0) }
        scope :soldout, -> { where('quantity <= ?', 0) }

        include InstanceMethods
      end
    end

    module InstanceMethods
      private

      def alias_methods_to_comable_stock_accsesor
        config = Comable::Engine::config
        return unless config.respond_to?(:stock_columns)

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

ActiveRecord::Base.send :include, Comable::ActsAsComableStock::Base
