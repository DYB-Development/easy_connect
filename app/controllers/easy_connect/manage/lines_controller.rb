module EasyConnect
  module Manage
    class LinesController < BaseController
      def create
        board.connect(params[:from], params[:to])
        head :no_content
      end

      def destroy
        board.disconnect(params[:from], params[:to])
        head :no_content
      end

      private

      def board
        @board ||= hosted_boards.find(params[:board_id])
      end
    end
  end
end
