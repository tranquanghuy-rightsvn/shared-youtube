class Video < ActiveRecord::Base
  belongs_to :user

  scope :newest, -> { order(created_at: :desc) }

  def title
    video.title
  end

  def embed_url
    video.embed_url
  end

  def description
    video.description
  end

  private

  def video
    VideoInfo.new(url)
  end
end
