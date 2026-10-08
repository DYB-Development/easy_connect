require "test_helper"

class EasyConnect::BoardLinesTest < ActiveSupport::TestCase
  setup do
    @board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: [
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
      { "id" => "DYB-2", "label" => "Invoices", "group" => "Tickets" },
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
    ])
  end

  test "a line drawn from an item in the first group to one in the second is kept" do
    @board.connect("DYB-1", "PR-7")

    assert_equal [ { "from" => "DYB-1", "to" => "PR-7" } ], @board.reload.lines
  end

  test "a line drawn from the second group to the first is kept running from the first to the second" do
    @board.connect("PR-7", "DYB-1")

    assert_equal [ { "from" => "DYB-1", "to" => "PR-7" } ], @board.reload.lines
  end

  test "a second line between the same two items is refused" do
    @board.connect("DYB-1", "PR-7")

    assert_raises(EasyConnect::Refused) { @board.connect("PR-7", "DYB-1") }
  end

  test "a line removed from either end is gone" do
    @board.connect("DYB-1", "PR-7")

    @board.disconnect("PR-7", "DYB-1")

    assert_equal [], @board.reload.lines
  end
end
