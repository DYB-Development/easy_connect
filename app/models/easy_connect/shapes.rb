module EasyConnect
  module Shapes
    def self.named(name)
      all.fetch(name)
    end

    def self.known?(name)
      all.key?(name)
    end

    def self.all
      { "connections" => Connections, "ordering" => Ordering }
    end
  end
end
