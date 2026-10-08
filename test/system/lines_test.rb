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

    test "a line between two items in the same group is refused with the reason and not drawn" do
      visit easy_connect.manage_board_path(@board)

      find("[data-item='DYB-1']").drag_to(find("[data-item='DYB-2']"))

      assert_selector "[role='alert']", text: "Both items are in the same group."
    end

    test "an admin removes a line and it stays gone after the page is reloaded" do
      @board.connect("DYB-1", "PR-7")
      visit easy_connect.manage_board_path(@board)

      click_on "Remove the line from Billing report to Add the report page"
      assert_no_selector "[data-line='DYB-1 PR-7']"
      visit easy_connect.manage_board_path(@board)

      assert_no_selector "[data-line='DYB-1 PR-7']"
    end
  end
end
