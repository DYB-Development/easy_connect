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
end
