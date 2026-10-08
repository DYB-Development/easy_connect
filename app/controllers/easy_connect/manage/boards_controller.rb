module EasyConnect
  module Manage
    class BoardsController < BaseController
      def show
        @board = hosted_boards.find(params[:id])
      end
    end
  end
end
