class AddLinesToEasyConnectBoards < ActiveRecord::Migration[8.1]
  def change
    add_column :easy_connect_boards, :lines, :json, null: false, default: []
  end
end
