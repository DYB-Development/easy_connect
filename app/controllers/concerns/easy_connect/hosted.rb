module EasyConnect
  module Hosted
    extend ActiveSupport::Concern

    private

    def connect_host
      @connect_host ||= EasyConnect.host_named(request.path_parameters[:easy_connect_host])
    end

    def hosted_boards
      return connect_host.boards unless connect_host.owner_method

      connect_host.boards.where(owner: send(connect_host.owner_method))
    end
  end
end
