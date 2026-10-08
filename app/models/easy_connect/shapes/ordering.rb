module EasyConnect
  module Shapes
    class Ordering
      def initialize(groups, items)
        @groups = groups
        @items = items
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
