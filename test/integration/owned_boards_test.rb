require "test_helper"

module EasyConnect
  class OwnedBoardsTest < ActionDispatch::IntegrationTest
    test "an admin of a host that names an owner cannot open another owner's board" do
      theirs = EasyConnect.host_named(:owned).boards.create!(owner: Account.create!, title: "Theirs", groups: [ "Tickets", "Pull requests" ], items: [])

      get "/owned/manage/boards/#{theirs.id}", headers: { "X-Account" => Account.create!.id.to_s }

      assert_response :not_found
    end
  end
end
