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
  end
end
