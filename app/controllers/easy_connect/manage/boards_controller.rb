module EasyConnect
  module Manage
    class BoardsController < BaseController
      def show
        @board = hosted_boards.find(params[:id])

        respond_to do |format|
          format.html
          format.json { render json: @board.drawing }
        end
      end
    end
  end
end
