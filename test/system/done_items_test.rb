require "application_system_test_case"

module EasyConnect
  class DoneItemsTest < ApplicationSystemTestCase
    setup do
      @board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
        { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
      ])
    end

    test "an admin marks an item done and the mark is still there after the page is reloaded" do
      visit easy_connect.manage_board_path(@board)

      within("[data-item='PR-7']") { click_on "Mark done" }
      assert_selector "[data-item='PR-7'][data-done]"
      visit easy_connect.manage_board_path(@board)

      assert_selector "[data-item='PR-7']", text: "Undo done"
    end
  end
end
