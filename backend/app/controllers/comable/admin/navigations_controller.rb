require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class NavigationsController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Navigation.name, except: :index

      def index
        @q = Comable::Navigation.ransack(params[:q])
        @navigations = @q.result.accessible_by(current_ability).by_newest
      end

      def show
        edit
        render :edit
      end

      def new
        @navigation.navigation_items.build
      end

      def edit
      end

      def create
        @navigation = Comable::Navigation.new(navigation_params)
        if @navigation.save
          redirect_to comable.admin_navigation_path(@navigation), notice: Comable.t('successful')
        else
          render :new
        end
      end

      def update
        @navigation.attributes = navigation_params
        if @navigation.save
          redirect_to comable.admin_navigation_path(@navigation), notice: Comable.t('successful')
        else
          render :edit
        end
      end

      def destroy
        @navigation.destroy
        redirect_to comable.admin_navigations_path, notice: Comable.t('successful')
      end

      def search_linkable_ids
        @linkable_id_options = Comable::NavigationItem.linkable_id_options(params[:linkable_type])
        render layout: false
      end

      private

      def navigation_params
        params.require(:navigation).permit(
          :name,
          navigation_items_attributes: navigation_items_attributes_keys
        )
      end

      def navigation_items_attributes_keys
        [
          :id,
          :position,
          :linkable_id,
          :linkable_type,
          :name,
          :url,
          :_destroy
        ]
      end
    end
  end
end
