require "test_helper"

module EasyConnect
  class SaveTest < ActionDispatch::IntegrationTest
    test "an admin saves a board" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

      post easy_connect.manage_board_save_path(board), as: :json

      assert board.reload.saved?
    end

    test "saving a board runs the method its host names and tells it which board was saved" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])
      EasyConnect.host_named(:dummy).after_save_method = :note_the_save

      post easy_connect.manage_board_save_path(board), as: :json

      assert_equal board.id.to_s, response.headers["X-Saved-Board"]
    ensure
      EasyConnect.host_named(:dummy).after_save_method = nil
    end
  end
end
