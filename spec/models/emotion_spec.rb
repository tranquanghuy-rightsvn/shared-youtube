require "rails_helper"

RSpec.describe Emotion, type: :model do
  describe "relationships" do
    it do
      is_expected.to belong_to(:video)
      is_expected.to belong_to(:user)
    end
  end

  describe "validations" do
    context "with video_id" do
      it{ is_expected.to_not validate_uniqueness_of(:user_id).scoped_to(:video_id) }
    end
  end

  describe "enum" do
    it { should define_enum_for(:emotion_type).with_values([:like, :dislike]) }
  end
end
