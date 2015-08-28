module Comable
  class Variant < ActiveRecord::Base
    include Comable::Ransackable

    belongs_to :product, class_name: Comable::Product.name, inverse_of: :variants
    has_one :stock, class_name: Comable::Stock.name, inverse_of: :variant, dependent: :destroy, autosave: true
    has_and_belongs_to_many :option_values, class_name: Comable::OptionValue.name, join_table: :comable_variants_option_values

    accepts_nested_attributes_for :option_values, allow_destroy: true
    accepts_nested_attributes_for :stock

    validates :product, presence: { message: Comable.t('admin.is_not_exists') }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :sku, length: { maximum: 255 }

    before_validation :set_option_values_from_names, if: :product

    ransack_options attribute_select: { associations: [:product, :stock, :option_values] }, ransackable_attributes: { except: :product_id }

    attr_writer :names

    def name
      names.join(' x ')
    end

    def names
      @names ? @names : option_values.map(&:name)
    end

    def quantity
      stock.try(:quantity) || build_stock.quantity
    end

    def quantity=(quantity)
      if stock
        stock.quantity = quantity
      else
        build_stock(quantity: quantity)
      end
    end

    # refs http://stackoverflow.com/questions/8776724/how-do-i-create-a-new-object-referencing-an-existing-nested-attribute/21215218#21215218
    def option_values_attributes=(attributes)
      if attributes.is_a? Array
        existed_option_values = attributes.map do |attr|
          variant = Comable::OptionValue.find_by(option_type: attr[:option_type], name: attr[:name]) unless attr[:id]
          next unless variant
          attr[:id] = variant.id
          variant
        end.compact
        self.attributes = { option_values: existed_option_values }
      end
      super
    end

    private

    def set_option_values_from_names
      return unless @names
      attributes = []
      @names.split(',').each.with_index do |name, index|
        option_type = product.option_types[index]
        attributes << { option_type: option_type, name: name }
      end
      self.names = nil
      self.option_values_attributes = attributes
    end
  end
end
