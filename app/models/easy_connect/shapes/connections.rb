module EasyConnect
  module Shapes
    class Connections
      def initialize(groups, items)
        @groups = groups
        @items = items
      end

      def line(from, to)
        ends = [ from, to ].sort_by { |id| @groups.index(group_of(id)) }

        { "from" => ends.first, "to" => ends.last }
      end

      private

      def group_of(id)
        @items.find { |item| item["id"] == id }&.dig("group")
      end
    end
  end
end
