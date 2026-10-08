require "test_helper"

module EasyConnect
  class BoardPageTest < ActionDispatch::IntegrationTest
    test "an admin opening a board's page gets the board drawn in one column per group" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" }
      ])

      get easy_connect.manage_board_path(board)

      assert_equal({ "columns" => board.columns }, JSON.parse(css_select("[data-react-ui='easy_connect/board']").first["data-props"]))
    end
  end
end
