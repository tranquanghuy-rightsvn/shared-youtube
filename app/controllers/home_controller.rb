class HomeController < ApplicationController
  def index
    @user = User.new
    @videos = Video.includes(:user).newest.page(params[:page]).per 5
  end
end
