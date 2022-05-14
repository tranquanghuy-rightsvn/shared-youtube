require "rails_helper"

RSpec.describe Video, type: :model do
  describe "relationships" do
    it do
      is_expected.to belong_to(:user)
      is_expected.to have_many(:emotions)
    end
  end

  describe "validations" do
    subject { create :video }

    context "with url" do
      it do
        is_expected.to validate_presence_of(:url)
        is_expected.to validate_uniqueness_of(:url).case_insensitive
      end
    end

    context "with title" do
      it do
        is_expected.to validate_presence_of(:title)
      end
    end

    context "with embed_url" do
      it do
        is_expected.to validate_presence_of(:embed_url)
      end
    end
  end

  describe "scope" do
    context "newest" do
      let!(:video_1){ create :video }
      let!(:video_2){ create :video }
      let!(:video_3){ create :video }

      it{ expect(Video.newest.first).to eq video_3 }
      it{ expect(Video.newest.second).to eq video_2 }
      it{ expect(Video.newest.third).to eq video_1 }
      it{ expect(Video.newest.count).to eq 3 }
    end

    context "with_count_like" do
      let(:video_1){ create :video }
      let(:video_2){ create :video }

      let!(:emotion_1){ create :emotion, video: video_1, emotion_type: 0 }
      let!(:emotion_2){ create :emotion, video: video_1, emotion_type: 0 }
      let!(:emotion_3){ create :emotion, video: video_1, emotion_type: 0 }

      let!(:emotion_4){ create :emotion, video: video_2, emotion_type: 1 }
      let!(:emotion_5){ create :emotion, video: video_2, emotion_type: 0 } 

      let!(:video_3){ create :video }

      it{ expect(Video.with_count_like.first.id).to eq video_1.id }
      it{ expect(Video.with_count_like.second.id).to eq video_2.id }
      it{ expect(Video.with_count_like.third.id).to eq video_3.id }

      it{ expect(Video.with_count_like.first.count_like).to eq 3}
      it{ expect(Video.with_count_like.second.count_like).to eq 1 }
      it{ expect(Video.with_count_like.third.count_like).to eq 0 }
    end
  end


  describe "instanse method" do
    context "count_dislike" do
      let(:video_1){ create :video }

      let!(:emotion_1){ create :emotion, video: video_1, emotion_type: 0 }
      let!(:emotion_2){ create :emotion, video: video_1, emotion_type: 0 }
      let!(:emotion_3){ create :emotion, video: video_1, emotion_type: 1 }

      let!(:video_first){ Video.with_count_like.first}

      it{ expect(video_first.count_dislike).to eq 1 }
    end

    context "like_voted_by? user_id" do
      let(:video_1){ create :video }
      let(:video_2){ create :video }

      let(:user){ create :user }

      let!(:emotion_1){ create :emotion, video: video_1, user: user, emotion_type: 0 }

      it{ expect(video_1.like_voted_by?(user.id)).to eq "voted" }
      it{ expect(video_2.like_voted_by?(user.id)).to eq "" }
    end
  end
end
