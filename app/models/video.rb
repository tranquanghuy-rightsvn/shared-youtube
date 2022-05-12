class Video < ActiveRecord::Base
  belongs_to :user
  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true
  validates :embed_url, presence: true

  scope :newest, -> { order(created_at: :desc) }
end
