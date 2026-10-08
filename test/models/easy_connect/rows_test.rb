require "test_helper"

class EasyConnect::RowsTest < ActiveSupport::TestCase
  def line(from, to)
    { "from" => from, "to" => to }
  end

  test "each item sits in the row given by the fewest lines from an item no line enters" do
    rows = EasyConnect::Rows.new(%w[plan build review ship], [
      line("plan", "build"), line("plan", "review"), line("build", "ship"), line("review", "ship"), line("plan", "ship")
    ])

    assert_equal({ "plan" => 0, "build" => 1, "review" => 1, "ship" => 1 }, rows.rows)
  end

  test "items no starting item leads to all sit in one row below every other row" do
    rows = EasyConnect::Rows.new(%w[plan build loop_a loop_b], [
      line("plan", "build"), line("loop_a", "loop_b"), line("loop_b", "loop_a")
    ])

    assert_equal({ "plan" => 0, "build" => 1, "loop_a" => 2, "loop_b" => 2 }, rows.rows)
  end
end
