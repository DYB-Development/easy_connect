require "test_helper"

class EasyConnect::BoardTest < ActiveSupport::TestCase
  test "a board keeps the items it was created with" do
    items = [ { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" } ]

    board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: items)

    assert_equal items, board.reload.items
  end

  test "a new board's result lists its item ids and no lines" do
    board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: [
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
    ])

    assert_equal({ "items" => [ "DYB-1", "PR-7" ], "lines" => [] }, JSON.parse(board.result))
  end
end
