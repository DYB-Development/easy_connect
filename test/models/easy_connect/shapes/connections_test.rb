require "test_helper"

class EasyConnect::Shapes::ConnectionsTest < ActiveSupport::TestCase
  setup do
    @shape = EasyConnect::Shapes::Connections.new([ "Tickets", "Pull requests" ], [
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
      { "id" => "DYB-2", "label" => "Invoices", "group" => "Tickets" },
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
    ])
  end

  test "a line dragged from the second group runs from the first group to the second" do
    assert_equal({ "from" => "DYB-1", "to" => "PR-7" }, @shape.line("PR-7", "DYB-1"))
  end
end
