require "keystone_ui/react/mount_helper"

module EasyConnect
  module Manage
    class BaseController < EasyConnect.base_controller.constantize
      include Hosted
      include AuthenticatesAdmin

      layout -> { connect_host.admin_layout }

      helper KeystoneUi::React::MountHelper
    end
  end
end
