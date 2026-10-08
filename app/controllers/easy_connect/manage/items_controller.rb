module EasyConnect
  module Manage
    class ItemsController < BaseController
      def update
        hosted_boards.find(params[:board_id]).mark(params[:id], done: ActiveModel::Type::Boolean.new.cast(params[:done]))
        head :no_content
      end
    end
  end
end
