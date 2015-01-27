module Comable
  class Category < ActiveRecord::Base
    has_and_belongs_to_many :products, class_name: Comable::Product.name, join_table: :comable_products_categories
    has_ancestry

    DEFAULT_PATH_NAME_DELIMITER = ' > '

    class << self
      def path_names(delimiter: DEFAULT_PATH_NAME_DELIMITER)
        categoris.path(&:name).join(delimiter)
      end

      def find_by_path_names(path_names, delimiter: DEFAULT_PATH_NAME_DELIMITER)
        path_names.map do |path_name|
          find_by_path_name(path_name, delimiter: delimiter)
        end.compact
      end

      def find_by_path_name(path_name, root: nil, delimiter: DEFAULT_PATH_NAME_DELIMITER)
        names = path_name.split(delimiter)
        names.inject(root) do |category, name|
          (category ? category.children : roots).find_by(name: name) || return
        end
      end

      def to_jstree(options = {})
        build_jstree(arrange_serializable, options).to_json
      end

      def from_jstree!(jstree_json)
        jstree = JSON.parse(jstree_json)
        rebuild_by_jstree!(jstree)
      end

      private

      def build_jstree(serialized_categories, options = {})
        serialized_categories.map do |serialized_category|
          options.merge(
            id: serialized_category['id'],
            text: serialized_category['name'],
            children: build_jstree(serialized_category['children'], options)
          )
        end
      end

      def rebuild_by_jstree!(jstree, parent = nil)
        return if jstree.blank?

        jstree.each do |node|
          next find(node['_destroy']).destroy! if node['_destroy'].present?

          category = node['id'].to_i.zero? ? new : find(node['id'])
          category.update_attributes!(
            parent: parent,
            name: node['text']
          )

          rebuild_by_jstree!(node['children'], category)
        end
      end
    end
  end
end
