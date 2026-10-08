require "easy_connect/version"
require "easy_connect/host"
require "easy_connect/engine"

module EasyConnect
  class << self
    attr_writer :base_controller

    def base_controller
      @base_controller || "ActionController::Base"
    end

    def host(name)
      hosts[name.to_s] = Host.new(name)
    end

    def hosts
      @hosts ||= {}
    end

    def host_named(name)
      hosts.fetch(name.to_s)
    end
  end
end
