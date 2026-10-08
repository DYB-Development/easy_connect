require "test_helper"

module EasyConnect
  class ItemsTest < ActionDispatch::IntegrationTest
    test "an admin marks an item done" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" }
      ])

      patch easy_connect.manage_board_item_path(board, "DYB-1"), params: { done: true }, as: :json

      assert_equal true, board.reload.items.first["done"]
    end

    test "marking an item not on the board is answered with the reason it was refused" do
      board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

      patch easy_connect.manage_board_item_path(board, "PR-99"), params: { done: true }, as: :json

      assert_equal [ 422, "That item is not on this board." ], [ response.status, response.parsed_body["error"] ]
    end
  end
end
