class HomeController < ApplicationController
  def index
    @user = User.new
    @video = VideoInfo.new('https://www.youtube.com/watch?v=mr0gyhwXM4w')


    @title = @video.title
  end
end
