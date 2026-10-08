require "test_helper"

class EasyConnectTest < ActiveSupport::TestCase
  test "a registered host is found by its name" do
    host = EasyConnect.host(:billing)

    assert_same host, EasyConnect.host_named("billing")
  end

  test "admin pages inherit from Action Controller's base unless the host app names its own controller" do
    named = EasyConnect.base_controller
    EasyConnect.base_controller = nil

    assert_equal "ActionController::Base", EasyConnect.base_controller
  ensure
    EasyConnect.base_controller = named
  end
end
