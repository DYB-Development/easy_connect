module EasyConnect
  class Board < ApplicationRecord
    self.table_name = "easy_connect_boards"

    belongs_to :owner, polymorphic: true, optional: true

    def result
      { items: items.pluck("id"), lines: [] }.to_json
    end

    def columns
      groups.map do |group|
        { "name" => group, "items" => items.select { |item| item["group"] == group }.map { |item| item.slice("id", "label") } }
      end
    end
  end
end
