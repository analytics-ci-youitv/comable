module Comable
  class CartsController < Comable::ApplicationController
    before_filter :set_cart_item, only: [:add, :update, :destroy]
    before_filter :ensure_found_cart_item, only: [:add, :update, :destroy]

    def add
      if current_comable_user.add_cart_item(@cart_item, cart_item_options)
        redirect_to comable.cart_path, notice: Comable.t('carts.added')
      else
        flash.now[:alert] = Comable.t('carts.invalid')
        render :show
      end
    end

    def update
      if current_comable_user.reset_cart_item(@cart_item, cart_item_options)
        redirect_to comable.cart_path, notice: Comable.t('carts.updated')
      else
        flash.now[:alert] = Comable.t('carts.invalid')
        render :show
      end
    end

    def destroy
      if current_comable_user.reset_cart_item(@cart_item)
        redirect_to comable.cart_path, notice: Comable.t('carts.updated')
      else
        flash.now[:alert] = Comable.t('carts.invalid')
        render :show
      end
    end

    def checkout
      current_order.next_state if current_order.state?(:cart)
      redirect_to comable.next_order_path(state: :confirm)
    end

    private

    def set_cart_item
      @cart_item = find_cart_item
    end

    def ensure_found_cart_item
      return if @cart_item
      redirect_to :back, alert: Comable.t('errors.messages.products_not_found')
    end

    def find_cart_item
      cart_item = Comable::Stock.where(id: params[:stock_id]).first
      cart_item ||= find_variant
      cart_item ||= Comable::Product.where(id: params[:product_id]).first
      return unless cart_item
      return if cart_item.is_a?(Comable::Product) && cart_item.sku?
      cart_item
    end

    def find_variant
      Comable::Variant.joins(:option_values).where(
        Comable::OptionValue.table_name => { id: params[:option_values] }
      ).first
    end

    def cart_item_options
      options = {}
      options.update(quantity: params[:quantity].to_i) if params[:quantity]
      options
    end
  end
end
