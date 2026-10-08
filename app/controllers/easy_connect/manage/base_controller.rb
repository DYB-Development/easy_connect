require "keystone_ui/react/mount_helper"

module EasyConnect
  module Manage
    class BaseController < EasyConnect.base_controller.constantize
      include Hosted
      include AuthenticatesAdmin

      layout -> { connect_host.admin_layout }

      helper KeystoneUi::React::MountHelper

      helper_method :connect_routes

      rescue_from Refused do |refusal|
        render json: { error: refusal.message }, status: :unprocessable_entity
      end

      private

      def connect_routes
        @connect_routes ||= ActionDispatch::Routing::RoutesProxy.new(_routes, self, _routes.url_helpers)
      end
    end
  end
end
