module EasyConnect
  class Board < ApplicationRecord
    self.table_name = "easy_connect_boards"

    SHOWN = %w[id label details url done].freeze

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

    def add_items(added)
      update!(items: items + added.map(&:stringify_keys))
    end

    def remove_items(ids)
      update!(items: items.reject { |item| ids.include?(item["id"]) },
        lines: lines.reject { |line| ids.include?(line["from"]) || ids.include?(line["to"]) })
    end

    def mark(id, done:)
      raise Refused, "That item is not on this board." unless items.any? { |item| item["id"] == id }

      update!(items: items.map { |item| item["id"] == id ? item.merge("done" => done) : item })
    end

    def shape_rules
      Shapes.named(shape).new(groups, items, lines)
    end

    def drawing
      shape_rules.placement(SHOWN).merge("lines" => lines, "saved_at" => saved_at&.iso8601)
    end
  end
end
