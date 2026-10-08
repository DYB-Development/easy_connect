require "test_helper"

class EasyConnect::BadItemsTest < ActiveSupport::TestCase
  def create(groups: [ "Tickets", "Pull requests" ], items: [], shape: "connections")
    EasyConnect::Board.create!(host: "billing", title: "October", shape: shape, groups: groups, items: items)
  end

  test "a board with two items that share an id is refused and names the id" do
    error = assert_raises(ActiveRecord::RecordInvalid) do
      create(items: [ { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" }, { "id" => "DYB-1", "label" => "Invoices", "group" => "Tickets" } ])
    end

    assert_includes error.message, "DYB-1"
  end

  test "adding an item whose id the board already holds is refused" do
    board = create(items: [ { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" } ])

    assert_raises(ActiveRecord::RecordInvalid) { board.add_items([ { "id" => "DYB-1", "label" => "Again", "group" => "Tickets" } ]) }
  end

  test "an item with no label is refused and named" do
    error = assert_raises(ActiveRecord::RecordInvalid) { create(items: [ { "id" => "DYB-1", "group" => "Tickets" } ]) }

    assert_includes error.message, "DYB-1 has no label"
  end
end
