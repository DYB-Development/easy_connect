class AddSavedAtToEasyConnectBoards < ActiveRecord::Migration[8.1]
  def change
    add_column :easy_connect_boards, :saved_at, :datetime
  end
end
