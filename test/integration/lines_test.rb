require "test_helper"

module EasyConnect
  class LinesTest < ActionDispatch::IntegrationTest
    setup do
      @board = EasyConnect.host_named(:dummy).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [
        { "id" => "DYB-1", "label" => "Billing report", "group" => "Tickets" },
        { "id" => "DYB-2", "label" => "Invoices", "group" => "Tickets" },
        { "id" => "PR-7", "label" => "Add the report page", "group" => "Pull requests" }
      ])
    end

    test "an admin draws a line between two items of a board" do
      post easy_connect.manage_board_lines_path(@board), params: { from: "PR-7", to: "DYB-1" }, as: :json

      assert_equal [ { "from" => "DYB-1", "to" => "PR-7" } ], @board.reload.lines
    end

    test "a refused line is answered with the reason it was refused" do
      post easy_connect.manage_board_lines_path(@board), params: { from: "DYB-1", to: "DYB-2" }, as: :json

      assert_equal [ 422, "Both items are in the same group." ], [ response.status, response.parsed_body["error"] ]
    end

    test "an admin removes a line from a board" do
      @board.connect("DYB-1", "PR-7")

      delete easy_connect.manage_board_lines_path(@board), params: { from: "DYB-1", to: "PR-7" }, as: :json

      assert_equal [], @board.reload.lines
    end

    test "the board page fetches the board's drawing again after an edit" do
      @board.connect("DYB-1", "PR-7")

      get easy_connect.manage_board_path(@board, format: :json)

      assert_equal @board.drawing, response.parsed_body
    end
  end
end
