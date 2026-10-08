require "test_helper"

class EasyConnect::BoardTest < ActiveSupport::TestCase
  test "a board keeps the items it was created with" do
    items = [ { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" } ]

    board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: items)

    assert_equal items, board.reload.items
  end
end
