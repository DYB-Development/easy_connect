module EasyConnect
  module Shapes
    class Ordering
      def initialize(groups, items)
        @groups = groups
        @items = items
      end

      def line(from, to)
        raise Refused, "A line cannot run from an item to itself." if from == to

        { "from" => from, "to" => to }
      end
    end
  end
end
