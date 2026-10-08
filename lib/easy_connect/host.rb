module EasyConnect
  class Host
    attr_reader :name
    attr_writer :admin_layout
    attr_accessor :admin_authentication_method, :owner_method, :after_save_method

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
