class Video < ActiveRecord::Base
  belongs_to :user
  has_many :emotions

  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true
  validates :embed_url, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :with_count_like, (lambda do
    select("videos.*, COUNT(emotions.id) as count_like")
      .joins("LEFT OUTER JOIN emotions ON emotions.video_id = videos.id AND emotions.emotion_type = 0")
      .group("videos.id")
  end)

  def count_dislike
    emotions.count - count_like
  end

  def like_voted_by? current_user_id
    emotion = emotions.find { |emo| emo.user_id == current_user_id && emo.emotion_type == "like"}

    emotion.present? ? "voted" : ""
  end

  def dislike_voted_by? current_user_id
    emotion = emotions.find { |emo| emo.user_id == current_user_id && emo.emotion_type == "dislike"} 

    emotion.present? ? "voted" : ""
  end
end
