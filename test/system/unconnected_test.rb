require "application_system_test_case"

module EasyConnect
  class UnconnectedTest < ApplicationSystemTestCase
    setup do
      @board = EasyConnect.host_named(:dummy).boards.create!(shape: "ordering", title: "Release", groups: [ "Steps" ], items: [
        { "id" => "plan", "label" => "Plan", "group" => "Steps" },
        { "id" => "build", "label" => "Build", "group" => "Steps" },
        { "id" => "test", "label" => "Test", "group" => "Steps" }
      ])
      @board.connect("plan", "build")
    end

    test "saving an ordering board with an item no line touches names it and asks first" do
      visit easy_connect.manage_board_path(@board)

      click_on "Save"

      assert_selector "[role='alertdialog']", text: "Test"
    end
  end
end
