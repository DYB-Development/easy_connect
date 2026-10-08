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

  test "a board's columns hold each group's items in the order the host handed them in" do
    board = EasyConnect::Board.new(groups: [ "Tickets", "Pull requests" ], items: [
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" },
      { "id" => "DYB-2", "label" => "Invoices", "group" => "Tickets" },
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" }
    ])

    assert_equal [
      { "name" => "Tickets", "items" => [ { "id" => "DYB-2", "label" => "Invoices" }, { "id" => "DYB-1", "label" => "Billing report" } ] },
      { "name" => "Pull requests", "items" => [ { "id" => "PR-7", "label" => "Add the report page" } ] }
    ], board.columns
  end

  test "a new board has no lines" do
    assert_equal [], EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: []).lines
  end

  test "a board's drawing holds its columns and its lines" do
    board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: [
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
    ])
    board.connect("DYB-1", "PR-7")

    assert_equal({ "columns" => board.columns, "lines" => [ { "from" => "DYB-1", "to" => "PR-7" } ] }, board.drawing)
  end

  test "a new board has not been saved" do
    assert_not EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: []).saved?
  end

  test "a saved board records when it was saved" do
    board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

    freeze_time do
      board.mark_saved!

      assert_equal Time.current, board.reload.saved_at
    end
  end
end
