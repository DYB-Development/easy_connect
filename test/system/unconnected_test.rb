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

    test "the admin goes back to drawing without saving" do
      visit easy_connect.manage_board_path(@board)

      click_on "Save"
      click_on "Keep drawing"

      assert_no_selector "[role='alertdialog']"
      assert_selector "[data-saved]", text: "Not saved yet"
    end

    test "the admin saves anyway" do
      visit easy_connect.manage_board_path(@board)

      click_on "Save"
      click_on "Save anyway"

      assert_selector "[data-saved]", text: "Saved "
    end

    test "an ordering board where every item has a line saves without asking" do
      @board.connect("build", "test")
      visit easy_connect.manage_board_path(@board)

      click_on "Save"

      assert_selector "[data-saved]", text: "Saved "
    end
  end
end
