class ApplicationController < ActionController::Base
  def turn_away_the_admin
    head :forbidden
  end
end
