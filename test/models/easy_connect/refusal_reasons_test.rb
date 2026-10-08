require "test_helper"

class EasyConnect::RefusalReasonsTest < ActiveSupport::TestCase
  def board(shape, groups, items)
    EasyConnect::Board.create!(host: "billing", shape: shape, title: "October", groups: groups,
      items: items.map { |id, group| { "id" => id, "label" => id, "group" => group } })
  end

  def reasons(board, *lines)
    lines.map do |from, to|
      board.connect(from, to)
      nil
    rescue EasyConnect::Refused => refusal
      refusal.message
    end
  end

  test "a connections board refuses each kind of line with the same reasons as before" do
    connections = board("connections", [ "Tickets", "Pull requests" ], "DYB-1" => "Tickets", "DYB-2" => "Tickets", "PR-7" => "Pull requests")

    assert_equal [ nil, "Those two items are already joined.", "Both items are in the same group.", "That item is not on this board." ],
      reasons(connections, %w[DYB-1 PR-7], %w[PR-7 DYB-1], %w[DYB-1 DYB-2], %w[DYB-1 PR-99])
  end

  test "an ordering board refuses each kind of line with the same reasons as before" do
    ordering = board("ordering", [ "Steps" ], "plan" => "Steps", "build" => "Steps")

    assert_equal [ nil, "Those two items are already joined.", "A line cannot run from an item to itself.", "That item is not on this board." ],
      reasons(ordering, %w[plan build], %w[plan build], %w[plan plan], %w[plan ship])
  end
end
