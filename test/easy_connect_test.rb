require "test_helper"

class EasyConnectTest < ActiveSupport::TestCase
  test "a registered host is found by its name" do
    host = EasyConnect.host(:billing)

    assert_same host, EasyConnect.host_named("billing")
  end
end
