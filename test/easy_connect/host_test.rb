require "test_helper"
require "easy_connect/host"

class EasyConnect::HostTest < ActiveSupport::TestCase
  test "a host is named by the name it is given" do
    assert_equal "billing", EasyConnect::Host.new(:billing).name
  end
end
