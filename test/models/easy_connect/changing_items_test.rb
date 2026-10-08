require "test_helper"

class EasyConnect::ChangingItemsTest < ActiveSupport::TestCase
  setup do
    @board = EasyConnect::Board.create!(host: "billing", title: "October", groups: [ "Tickets", "Pull requests" ], items: [
      { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
      { "id" => "DYB-2", "label" => "Invoices", "group" => "Tickets" },
      { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
    ])
  end

  test "host code adds items to an existing board" do
    @board.add_items([ { "id" => "PR-8", "label" => "Fix the totals", "group" => "Pull requests" } ])

    assert_equal %w[DYB-1 DYB-2 PR-7 PR-8], @board.reload.items.pluck("id")
  end
end
