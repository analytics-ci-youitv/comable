module Comable
  class Engine < ::Rails::Engine
    config.product_table = :products
    config.product_columns = { name: :title }
    config.customer_table = :customers
    config.stock_table = :stocks
    config.stock_columns = { quantity: :units }
  end
end
