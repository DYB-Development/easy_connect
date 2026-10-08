class ApplicationController < ActionController::Base
  def turn_away_the_admin
    head :forbidden
  end

  def note_the_save(board_id)
    response.headers["X-Saved-Board"] = board_id.to_s
    nil
  end

  def current_account
    Account.find_by(id: request.headers["X-Account"])
  end
end
