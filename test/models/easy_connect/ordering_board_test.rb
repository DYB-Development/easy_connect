require "test_helper"

class EasyConnect::OrderingBoardTest < ActiveSupport::TestCase
  setup do
    @board = EasyConnect::Board.create!(host: "billing", shape: "ordering", title: "Release", groups: [ "Steps" ], items: [
      { "id" => "plan", "label" => "Plan", "group" => "Steps" },
      { "id" => "build", "label" => "Build", "group" => "Steps" },
      { "id" => "ship", "label" => "Ship", "group" => "Steps" }
    ])
  end

  test "an ordering board keeps a line between two of its items in the direction it was drawn" do
    @board.connect("build", "plan")

    assert_equal [ { "from" => "build", "to" => "plan" } ], @board.reload.lines
  end

  test "an ordering board's drawing holds its items in rows, in the order the host handed them in" do
    @board.connect("plan", "ship")
    @board.connect("plan", "build")

    assert_equal [
      [ { "id" => "plan", "label" => "Plan" } ],
      [ { "id" => "build", "label" => "Build" }, { "id" => "ship", "label" => "Ship" } ]
    ], @board.drawing["rows"]
  end
end
