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
end
