require "test_helper"

module EasyConnect
  class SaveTest < ActionDispatch::IntegrationTest
    test "an admin saves a board" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

      post easy_connect.manage_board_save_path(board), as: :json

      assert board.reload.saved?
    end
  end
end
