module EasyConnect
  module Hosted
    extend ActiveSupport::Concern

    private

    def connect_host
      @connect_host ||= EasyConnect.host_named(request.path_parameters[:easy_connect_host])
    end

    def hosted_boards
      connect_host.boards
    end
  end
end
