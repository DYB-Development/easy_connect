module EasyConnect
  class Rows
    def initialize(ids, lines)
      @ids = ids
      @lines = lines
    end

    def rows
      walked = walk
      stranded = @ids - walked.keys

      walked.merge(stranded.index_with((walked.values.max || -1) + 1))
    end

    private

    def walk
      seen = {}
      frontier = starting_points.map { |id| [ id, 0 ] }

      until frontier.empty?
        id, depth = frontier.shift
        next if seen.key?(id)

        seen[id] = depth
        lines_from(id).each { |line| frontier << [ line["to"], depth + 1 ] }
      end

      seen
    end

    def starting_points
      arrived = @lines.map { |line| line["to"] }
      @ids.reject { |id| arrived.include?(id) }
    end

    def lines_from(id)
      @lines.select { |line| line["from"] == id }
    end
  end
end
