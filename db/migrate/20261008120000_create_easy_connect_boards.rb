class CreateEasyConnectBoards < ActiveRecord::Migration[8.1]
  def change
    create_table :easy_connect_boards do |t|
      t.string :host, null: false
      t.references :owner, polymorphic: true, index: false
      t.string :shape, null: false, default: "connections"
      t.string :title, null: false
      t.json :groups, null: false
      t.json :items, null: false
      t.timestamps
    end

    add_index :easy_connect_boards, [ :host, :owner_type, :owner_id ]
  end
end
