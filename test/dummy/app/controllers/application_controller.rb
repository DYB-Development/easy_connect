class ApplicationController < ActionController::Base
  def turn_away_the_admin
    head :forbidden
  end

  def current_account
    Account.find_by(id: request.headers["X-Account"])
  end
end
