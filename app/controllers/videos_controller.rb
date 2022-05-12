class VideosController < ApplicationController
  before_action :check_current_user, only: [:new, :create]
  
  def new
    @video = Form::ShareVideo.new
  end

  def create
    @video = Form::ShareVideo.new video_params

    if @video.share
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def video_params
    # params.require(:form_share_video).permit(:url).merge user_id: current_user.id
    params.fetch(:form_share_video, {}).permit(:url).merge user_id: current_user.id
  end

  def check_current_user
    redirect_to root_path unless current_user
  end
end