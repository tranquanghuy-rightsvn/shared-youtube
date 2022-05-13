class Emotion < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  enum emotion_type: { like: 0, dislike: 1 }

  validates :user_id, uniqueness: { scope: :video_id }
end
