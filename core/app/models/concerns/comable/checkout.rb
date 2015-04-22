module Comable
  module Checkout
    extend ActiveSupport::Concern

    included do
      state_machine initial: :cart do
        state :cart
        state :orderer
        state :delivery
        state :shipment
        state :payment
        state :confirm
        state :complete
        state :canceled
        state :returned
        state :resumed

        event :next_state do
          transition :cart => :orderer, if: :orderer_required?
          transition [:cart, :orderer] => :delivery, if: :delivery_required?
          transition [:cart, :orderer, :delivery] => :shipment, if: :shipment_required?
          transition [:cart, :orderer, :delivery, :shipment] => :payment, if: :payment_required?
          transition all - [:confirm, :complete] => :confirm
          transition :confirm => :complete
        end

        event :cancel do
          transition to: :canceled, from: :complete, if: :allow_cancel?
        end

        event :return do
          transition to: :returned, from: :complete, if: :allow_return?
        end

        event :resume do
          transition to: :resumed, from: :canceled
        end

        before_transition to: :complete do |order, _transition|
          order.complete
        end
      end

      with_options if: -> { stated?(:cart) } do |context|
        context.validates :email, presence: true
      end

      with_options if: -> { stated?(:orderer) } do |context|
        context.validates :bill_address, presence: true
      end

      with_options if: -> { stated?(:delivery) } do |context|
        context.validates :ship_address, presence: true
      end

      with_options if: -> { stated?(:payment) && payment_required? } do |context|
        context.validates :payment_method, presence: true
      end

      with_options if: -> { stated?(:shipment) && shipment_required? } do |context|
        context.validates :shipment_method, presence: true
      end

      with_options if: -> { stated?(:complete) } do |context|
        context.validates :code, presence: true
        context.validates :shipment_fee, presence: true
        context.validates :total_price, presence: true
      end
    end

    module ClassMethods
      def state_names
        state_machine.states.keys
      end
    end

    def stated?(target_state)
      target_state_index = self.class.state_names.index(target_state.to_sym)
      current_state_index = self.class.state_names.index(state_name)
      target_state_index < current_state_index
    end

    def orderer_required?
      bill_address.nil? || bill_address.new_record?
    end

    def delivery_required?
      ship_address.nil? || ship_address.new_record?
    end

    def payment_required?
      Comable::PaymentMethod.exists?
    end

    def shipment_required?
      Comable::ShipmentMethod.activated.exists?
    end

    def allow_cancel?
      # TODO: Implement shipments
      # !shipments.exists?
      true
    end

    def allow_return?
      # TODO: Implement shipments
      # shipments.exists?
      false
    end
  end
end
