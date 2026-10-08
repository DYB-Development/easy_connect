module EasyConnect
  module Shapes
    def self.named(name)
      { "connections" => Connections, "ordering" => Ordering }.fetch(name)
    end
  end
end
