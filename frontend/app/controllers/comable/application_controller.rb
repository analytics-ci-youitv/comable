module Comable
  class ApplicationController < ActionController::Base
    include Comable::ApplicationHelper

    protect_from_forgery with: :exception
    before_filter :set_view_path

    def set_view_path
      prepend_view_path current_store.theme.dir if current_store.theme
    end
  end
end
