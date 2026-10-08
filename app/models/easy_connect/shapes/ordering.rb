module EasyConnect
  module Shapes
    class Ordering
      def initialize(groups, items, lines = [])
        @groups = groups
        @items = items
        @lines = lines
      end

      def problems
        []
      end

      def placement(shown)
        placed = Rows.new(@items.pluck("id"), @lines).rows

        { "rows" => @items.group_by { |item| placed[item["id"]] }.sort.map { |_row, held| held.map { |item| item.slice(*shown) } } }
      end

      def line(from, to)
        raise Refused, "That item is not on this board." unless on_board?(from) && on_board?(to)
        raise Refused, "A line cannot run from an item to itself." if from == to

        { "from" => from, "to" => to }
      end

      private

      def on_board?(id)
        @items.any? { |item| item["id"] == id }
      end
    end
  end
end
