require "test_helper"

module EasyConnect
  class AdminAuthenticationTest < ActionDispatch::IntegrationTest
    test "the board page runs the host's admin sign-in first" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])
      EasyConnect.host_named(:dummy).admin_authentication_method = :turn_away_the_admin

      get easy_connect.manage_board_path(board)

      assert_response :forbidden
    ensure
      EasyConnect.host_named(:dummy).admin_authentication_method = nil
    end
  end
end
