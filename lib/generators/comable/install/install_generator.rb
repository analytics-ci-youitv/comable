# refs:
#   http://yuma300.hatenablog.com/entry/2013/08/15/221418
#   http://old.thoughtsincomputation.com/posts/cgfr3-part-3-adding-a-generator
#   http://www.dixis.com/?p=444
#   http://stackoverflow.com/questions/10053891/can-i-run-a-rake-task-inside-a-generator

require 'rails/generators/active_record'

module Comable
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :name, default: 'migration'

      def create_product_model
        return if Comable::Engine.config.respond_to?(:product_class)
        template 'models/product.rb', 'app/models/product.rb'
        migration_template 'migrations/create_products.rb', 'db/migrate/create_products.rb'
      end

      def create_stock_model
        return if Comable::Engine.config.respond_to?(:stock_class)
        template 'models/stock.rb', 'app/models/stock.rb'
        migration_template 'migrations/create_stocks.rb', 'db/migrate/create_stocks.rb'
      end

      def create_customer_model
        return if Comable::Engine.config.respond_to?(:customer_class)
        template 'models/customer.rb', 'app/models/customer.rb'
        migration_template 'migrations/create_customers.rb', 'db/migrate/create_customers.rb'
      end

      def create_order_model
        return if Comable::Engine.config.respond_to?(:order_class)
        template 'models/order.rb', 'app/models/order.rb'
        migration_template 'migrations/create_orders.rb', 'db/migrate/create_orders.rb'
      end

      def create_order_delivery_model
        return if Comable::Engine.config.respond_to?(:order_delivery_class)
        template 'models/order_delivery.rb', 'app/models/order_delivery.rb'
        migration_template 'migrations/create_order_deliveries.rb', 'db/migrate/create_order_deliveries.rb'
      end

      def create_order_detail_model
        return if Comable::Engine.config.respond_to?(:order_detail_class)
        template 'models/order_detail.rb', 'app/models/order_detail.rb'
        migration_template 'migrations/create_order_details.rb', 'db/migrate/create_order_details.rb'
      end

      def copy_migrations
        rake 'comable:install:migrations'
      end
    end
  end
end
