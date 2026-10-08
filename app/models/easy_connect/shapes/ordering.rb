module EasyConnect
  module Shapes
    class Ordering
      def initialize(groups, items)
        @groups = groups
        @items = items
      end

      def line(from, to)
        { "from" => from, "to" => to }
      end
    end
  end
end
