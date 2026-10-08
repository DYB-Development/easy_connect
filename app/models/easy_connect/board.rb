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
      { shape: shape, items: items.pluck("id"), lines: lines.map { |line| line.values_at("from", "to") } }.to_json
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
      return Shapes::Ordering.new(groups, items) if shape == "ordering"

      Shapes::Connections.new(groups, items)
    end

    def drawing
      { "columns" => columns, "lines" => lines, "saved_at" => saved_at&.iso8601 }
    end

    def columns
      groups.map do |group|
        { "name" => group, "items" => items.select { |item| item["group"] == group }.map { |item| item.slice("id", "label") } }
      end
    end
  end
end
