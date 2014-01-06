class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column_safety_to_products :name, :string, null: false
    add_column_safety_to_products :code, :string, null: false
  end

  private

  def add_column_safety_to_products(column_name, type_name, options={})
    return if Comable::Engine::config.product_columns[column_name]
    add_column Comable::Engine::config.product_table, column_name, type_name, options
  end
end
