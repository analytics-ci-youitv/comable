module Comable
  class Store < ActiveRecord::Base
    class << self
      def instance
        first || new(name: default_store_name)
      end

      def default_store_name
        'Comable store'
      end
    end

    def email_activate?
      email_activate_flag && email_sender.present?
    end
  end
end
