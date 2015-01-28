require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      before_filter :find_product, only: [:show, :edit, :update, :destroy]

      def show
        render :edit
      end

      def index
        @q = Comable::Product.ransack(params[:q])
        @products = @q.result.includes(:stocks).page(params[:page])
      end

      def new
        @product = Comable::Product.new
      end

      def create
        @product = Comable::Product.new
        if @product.update_attributes(product_params)
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def update
        if @product.update_attributes(product_params)
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        if @product.destroy
          redirect_to comable.admin_products_path, notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      private

      def find_product
        @product = Comable::Product.includes(:images).find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          :name,
          :code,
          :caption,
          :price,
          category_path_names: [],
          images_attributes: [:id, :file, :_destroy]
        )
      end
    end
  end
end
