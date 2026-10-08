module EasyConnect
  module Manage
    class LinesController < BaseController
      rescue_from Refused do |refusal|
        render json: { error: refusal.message }, status: :unprocessable_entity
      end

      def create
        board.connect(params[:from], params[:to])
        head :no_content
      end

      private

      def board
        @board ||= hosted_boards.find(params[:board_id])
      end
    end
  end
end
