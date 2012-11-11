class LeaderboardController < ApplicationController
  def index
    @users = User.ranked
  end
end
