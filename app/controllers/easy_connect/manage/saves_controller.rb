module EasyConnect
  module Manage
    class SavesController < BaseController
      def create
        hosted_boards.find(params[:board_id]).mark_saved!
        head :no_content
      end
    end
  end
end
