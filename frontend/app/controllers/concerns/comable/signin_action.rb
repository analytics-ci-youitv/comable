module Comable
  module SigninAction
    class << self
      def prepended(base)
        base.instance_eval do
          before_filter :ensure_signed_in_or_guest, except: :signin

          helper_method :resource
          helper_method :resource_name
          helper_method :devise_mapping
        end
      end
    end

    private

    def ensure_signed_in_or_guest
      return if @order.email
      store_location
      redirect_to comable.signin_order_path
    end

    def resource
      current_customer
    end

    def resource_name
      :customer
    end

    def devise_mapping
      Devise.mappings[resource_name]
    end

    # orderride OrdersController#order_params
    def order_params
      return super unless params[:state] == 'cart'
      order_params_for_signin
    end

    def order_params_for_signin
      params.fetch(:order, {}).permit(
        :email
      )
    end
  end
end
