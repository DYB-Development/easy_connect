require "application_system_test_case"

module EasyConnect
  class OrderingTest < ApplicationSystemTestCase
    setup do
      @board = EasyConnect.host_named(:dummy).boards.create!(shape: "ordering", title: "Release", groups: [ "Steps" ], items: [
        { "id" => "plan", "label" => "Plan", "group" => "Steps" },
        { "id" => "build", "label" => "Build", "group" => "Steps" }
      ])
    end

    test "an admin drags from one item to another and the second moves to the row after the first" do
      visit easy_connect.manage_board_path(@board)

      find("[data-item='plan']").drag_to(find("[data-item='build']"))

      assert_selector "[data-row='1'] [data-item='build']"
    end
  end
end
