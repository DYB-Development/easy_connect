module EasyConnect
  class Board < ApplicationRecord
    self.table_name = "easy_connect_boards"

    belongs_to :owner, polymorphic: true, optional: true

    def result
      { items: items.pluck("id"), lines: [] }.to_json
    end
  end
end
