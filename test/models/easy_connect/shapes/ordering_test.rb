require "test_helper"

class EasyConnect::Shapes::OrderingTest < ActiveSupport::TestCase
  setup do
    @shape = EasyConnect::Shapes::Ordering.new([ "Steps" ], [
      { "id" => "plan", "label" => "Plan", "group" => "Steps" },
      { "id" => "build", "label" => "Build", "group" => "Steps" }
    ])
  end

  test "a line runs from the item dragged from to the item dropped on" do
    assert_equal({ "from" => "build", "to" => "plan" }, @shape.line("build", "plan"))
  end
end
