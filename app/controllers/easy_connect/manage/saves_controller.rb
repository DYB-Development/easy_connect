module EasyConnect
  module Manage
    class SavesController < BaseController
      def create
        board = hosted_boards.find(params[:board_id])
        board.mark_saved!
        send(connect_host.after_save_method, board.id) if connect_host.after_save_method

        head :no_content
      end
    end
  end
end
