require "application_system_test_case"

module EasyConnect
  class SaveTest < ApplicationSystemTestCase
    test "an admin saves a board from its page and sees that it was saved" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])
      visit easy_connect.manage_board_path(board)

      click_on "Save"

      assert_selector "[data-saved]", text: "Saved "
    end
  end
end
