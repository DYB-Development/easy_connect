require "test_helper"

module EasyConnect
  class BoardPageTest < ActionDispatch::IntegrationTest
    test "an admin opening a board's page gets the board's drawing and where to send edits" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" }
      ])

      get easy_connect.manage_board_path(board)

      props = JSON.parse(css_select("[data-react-ui='easy_connect/board']").first["data-props"])

      assert_equal({ "base" => easy_connect.manage_board_path(board), "initial" => board.drawing }, props.except("token"))
    end
  end
end
