module EasyConnect
  class Board < ApplicationRecord
    self.table_name = "easy_connect_boards"

    belongs_to :owner, polymorphic: true, optional: true

    def mark_saved!
      update!(saved_at: Time.current)
    end

    def saved?
      saved_at.present?
    end

    def result
      { items: items.pluck("id"), lines: [] }.to_json
    end

    def connect(from, to)
      line = shape_rules.line(from, to)
      raise Refused, "Those two items are already joined." if lines.include?(line)

      update!(lines: lines + [ line ])
    end

    def disconnect(from, to)
      update!(lines: lines - [ shape_rules.line(from, to) ])
    end

    def shape_rules
      Shapes::Connections.new(groups, items)
    end

    def drawing
      { "columns" => columns, "lines" => lines }
    end

    def columns
      groups.map do |group|
        { "name" => group, "items" => items.select { |item| item["group"] == group }.map { |item| item.slice("id", "label") } }
      end
    end
  end
end
