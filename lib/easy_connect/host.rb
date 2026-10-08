module EasyConnect
  class Host
    attr_reader :name

    def initialize(name)
      @name = name.to_s
    end

    def boards
      Board.where(host: name)
    end
  end
end
