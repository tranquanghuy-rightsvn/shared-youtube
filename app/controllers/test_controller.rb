class TestController < ApplicationController
  def index
    @video = VideoInfo.new('https://www.youtube.com/watch?v=mr0gyhwXM4w')


    @title = @video.title
  end
end