require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class ProductsController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Product.name, except: :index

      def index
        @q = Comable::Product.ransack(params[:q])
        @products = @q.result(distinct: true).includes(:stocks, :images).page(params[:page]).accessible_by(current_ability)
      end

      def show
        render :edit
      end

      def new
        @product.variants.build
        # @product.option_types.build(name: Comable.t('admin.size'))
        @product.published_at = Date.today
      end

      def create
        if @product.save
          redirect_to comable.admin_product_path(@product), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
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

      def export
        q = Comable::Product.ransack(params[:q])
        products = q.result.accessible_by(current_ability)

        respond_to_export_with products
      end

      def import
        ActiveRecord::Base.transaction do
          Comable::Product.import_from(params[:file])
        end
        redirect_to comable.admin_products_path, notice: Comable.t('successful')
      rescue Comable::Importable::Exception => e
        redirect_to comable.admin_products_path, alert: e.message
      end

      private

      def product_params
        params.require(:product).permit(
          :name,
          :caption,
          :published_at,
          category_path_names: [],
          images_attributes: [:id, :file, :_destroy],
          variants_attributes: [:id, :price, :sku, :names, :quantity, :_destroy],
          option_types_attributes: [:id, :name, { values: [] }]
        )
      end
    end
  end
end
