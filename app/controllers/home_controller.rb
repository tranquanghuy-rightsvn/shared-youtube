class HomeController < ApplicationController
  def index
    @user = User.new
    @videos = Video.includes(:user, :emotions).with_count_like.newest.page(params[:page]).per 5
  end
end
