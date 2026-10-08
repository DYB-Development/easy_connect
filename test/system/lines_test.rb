require "application_system_test_case"

module EasyConnect
  class LinesTest < ApplicationSystemTestCase
    setup do
      @board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
        { "id" => "DYB-2", "label" => "Invoices", "group" => "Tickets" },
        { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
      ])
    end

    test "an admin drags from one item to an item in the other group and a line appears" do
      visit easy_connect.manage_board_path(@board)

      find("[data-item='DYB-1']").drag_to(find("[data-item='PR-7']"))

      assert_selector "[data-line='DYB-1 PR-7']"
    end
  end
end
