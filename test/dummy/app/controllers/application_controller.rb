class ApplicationController < ActionController::Base
  helper Rails.application.routes.url_helpers

  def turn_away_the_admin
    head :forbidden
  end

  def note_the_save(board_id)
    response.headers["X-Saved-Board"] = board_id.to_s
    nil
  end

  def send_the_admin_on(board_id)
    "/billed/#{board_id}"
  end

  def current_account
    Account.find_by(id: request.headers["X-Account"])
  end
end
