require "application_system_test_case"

module EasyConnect
  class BoardPageTest < ApplicationSystemTestCase
    test "an admin sees each item as a node under its group's name" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
        { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
      ])

      visit easy_connect.manage_board_path(board)

      assert_selector "section", text: "Pull requests\nAdd the report page"
    end
  end
end
