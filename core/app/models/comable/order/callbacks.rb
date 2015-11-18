module Comable
  class Order < ActiveRecord::Base
    module Callbacks
      extend ActiveSupport::Concern

      included do
        define_model_callbacks :complete

        before_validation :copy_ship_address_from_bill_address, if: :same_as_bill_address
        before_validation :generate_code, on: :create
        before_validation :generate_guest_token, on: :create
        before_validation :clone_addresses_from_user, on: :create
        after_complete :clone_addresses_to_user
      end

      def generate_code
        self.code = loop do
          random_token = "C#{Array.new(11) { rand(9) }.join}"
          break random_token unless self.class.exists?(code: random_token)
        end
      end

      def generate_guest_token
        return if user
        self.guest_token ||= loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless self.class.exists?(guest_token: random_token)
        end
      end

      def clone_addresses_from_user
        return unless user
        self.bill_address ||= user.bill_address.try(:clone)
        self.ship_address ||= user.ship_address.try(:clone)
      end

      def clone_addresses_to_user
        return unless user
        user.update_bill_address_by bill_address
        user.update_ship_address_by ship_address
      end

      def copy_ship_address_from_bill_address
        self.ship_address = bill_address
      end
    end
  end
end
