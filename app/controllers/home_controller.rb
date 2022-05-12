class HomeController < ApplicationController
  def index
    @user = User.new
    @videos = Video.newest.page(params[:page]).per 3
  end
end
