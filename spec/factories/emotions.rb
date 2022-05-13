FactoryBot.define do
  factory :emotion do
    video{  create :video }
    user{ create :user }
    emotion_type{ [0, 1].sample }
  end
end
