require "test_helper"

class EasyConnect::DoneItemsTest < ActiveSupport::TestCase
  setup do
    @board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: [
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
    ])
  end

  test "an item marked done keeps the mark" do
    @board.mark("DYB-1", done: true)

    assert_equal true, @board.reload.items.first["done"]
  end
end
