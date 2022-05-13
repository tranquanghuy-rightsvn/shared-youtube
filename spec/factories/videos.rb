FactoryBot.define do
  factory :video do
    url{ "https://www.youtube.com/watch?v=#{FFaker::Address.city}" }
    embed_url{ "//www.youtube.com/embed/#{FFaker::Address.city}" }
    title{ "This is title of video"}
    description{ "This is description of video" }
    user{ create :user }
  end
end
