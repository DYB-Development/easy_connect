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
      update!(items: items.reject { |item| ids.include?(item["id"]) })
    end

    def mark(id, done:)
      raise Refused, "That item is not on this board." unless items.any? { |item| item["id"] == id }

      update!(items: items.map { |item| item["id"] == id ? item.merge("done" => done) : item })
    end

    def shape_rules
      return Shapes::Ordering.new(groups, items) if shape == "ordering"

      Shapes::Connections.new(groups, items)
    end

    def drawing
      placed = shape == "ordering" ? { "rows" => rows } : { "columns" => columns }

      placed.merge("lines" => lines, "saved_at" => saved_at&.iso8601)
    end

    def rows
      placed = Rows.new(items.pluck("id"), lines).rows

      items.group_by { |item| placed[item["id"]] }.sort.map { |_row, held| held.map { |item| item.slice(*SHOWN) } }
    end

    def columns
      groups.map do |group|
        { "name" => group, "items" => items.select { |item| item["group"] == group }.map { |item| item.slice(*SHOWN) } }
      end
    end
  end
end
