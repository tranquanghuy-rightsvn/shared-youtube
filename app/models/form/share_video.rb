module Form
  class ShareVideo
    include ActiveModel::Model

    FORMAT_YOUTUBE_LINK = /\A((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?\z/
    
    attr_accessor :url, :user_id
    
    validates :url, presence: true, format: { with: FORMAT_YOUTUBE_LINK }

    def share
      return false if invalid?

      video = VideoInfo.new url
      Video.create! embed_url: video.embed_url, description: video.description, title: video.title, user_id: user_id, url: url

      true
    rescue ActiveRecord::ActiveRecordError, VideoInfo::UrlError => e
      errors.add(:base, e.message)

      false
    end
  end
end
