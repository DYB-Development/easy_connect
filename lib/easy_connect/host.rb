module EasyConnect
  class Host
    attr_reader :name
    attr_writer :admin_layout

    def initialize(name)
      @name = name.to_s
    end

    def admin_layout
      @admin_layout || "application"
    end

    def boards
      Board.where(host: name)
    end
  end
end
