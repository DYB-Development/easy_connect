module EasyConnect
  module Shapes
    class Connections
      def initialize(groups, items, lines = [])
        @groups = groups
        @items = items
        @lines = lines
      end

      def placement(shown)
        { "columns" => @groups.map { |group| { "name" => group, "items" => held_by(group).map { |item| item.slice(*shown) } } } }
      end

      def line(from, to)
        raise Refused, "That item is not on this board." unless group_of(from) && group_of(to)
        raise Refused, "Both items are in the same group." if group_of(from) == group_of(to)

        ends = [ from, to ].sort_by { |id| @groups.index(group_of(id)) }

        { "from" => ends.first, "to" => ends.last }
      end

      private

      def held_by(group)
        @items.select { |item| item["group"] == group }
      end

      def group_of(id)
        @items.find { |item| item["id"] == id }&.dig("group")
      end
    end
  end
end
