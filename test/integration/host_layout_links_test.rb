require "test_helper"

module EasyConnect
  class HostLayoutLinksTest < ActionDispatch::IntegrationTest
    test "a board page inside the host's layout links with the host's own route helpers" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

      get easy_connect.manage_board_path(board)

      assert_select "nav a[href=?]", "/home"
    end
  end
end
