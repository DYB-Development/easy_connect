require "test_helper"
require "easy_connect/host"

class EasyConnect::HostTest < ActiveSupport::TestCase
  test "a host is named by the name it is given" do
    assert_equal "billing", EasyConnect::Host.new(:billing).name
  end

  test "a board created through a host belongs to that host" do
    board = EasyConnect::Host.new(:billing).boards.create!(title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

    assert_equal "billing", board.reload.host
  end

  test "a lookup scoped to another owner does not find a board" do
    host = EasyConnect::Host.new(:billing)
    board = host.boards.create!(owner: Account.create!, title: "October", groups: [ "Tickets", "Pull requests" ], items: [])

    assert_nil host.boards.where(owner: Account.create!).find_by(id: board.id)
  end
end
