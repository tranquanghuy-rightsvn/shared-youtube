class VideosController < ApplicationController
  before_action :authenticate_user!

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

  def reaction
    emotion = Emotion.find_by video_id: params[:id], user: current_user
    emotion_type = params[:emotion_type].to_i

    if emotion
      if emotion.read_attribute_before_type_cast(:emotion_type) == emotion_type
        destroy_emotion(emotion)
      else
        switch_emotion emotion
      end
    else
      Emotion.create! video_id: params[:id], user: current_user, emotion_type: emotion_type
    end

    @video = Video.with_count_like.find_by id: params[:id]

    respond_to do |format|
      format.js
    end
  end

  private

  def video_params
    params.require(:form_share_video).permit(:url).merge user_id: current_user.id
  end

  def check_current_user
    redirect_to root_path unless current_user
  end

  def switch_emotion emotion
    emotion.like? ? emotion.dislike! : emotion.like!
  end

  def destroy_emotion emotion
    emotion.destroy!
  end
end
