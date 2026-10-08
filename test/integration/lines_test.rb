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
  end
end
