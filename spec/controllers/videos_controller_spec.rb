require "rails_helper"

RSpec.describe VideosController, type: :controller do
  describe "GET #new" do
    context "when get request success" do
      let(:user){ create :user }
      before do
        sign_in user
        get :new
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(assigns.keys.include?("video")).to be true
        expect(response).to render_template(:new)
      end
    end

    context "when get request failed because authorized" do
      before{ get :new }

      it{ expect(response).to have_http_status(:found) }
    end
  end

  describe "POST #create" do
    context "when shared video success" do
      let(:user){ create :user }

      before do
        sign_in user
        post :create, params: { form_share_video: { url: "https://www.youtube.com/watch?v=uPUUN529Wnw" } }
      end

      it do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        expect(Video.last.url).to eq "https://www.youtube.com/watch?v=uPUUN529Wnw"
      end
    end

    context "when get request failed because authorized" do
      before{ post :create }

      it{ expect(response).to have_http_status(:found) }
    end

    context "when shared video failed beacause URL invalid" do
      let(:user){ create :user }

      before do
        sign_in user
        post :create, params: { form_share_video: { url: "abc" } }
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(Video.last).to eq nil
      end
    end
  end

  describe "POST #reaction" do
    context "when like success" do
      let(:user){ create :user }
      let!(:video){ create :video }

      before do
        sign_in user
        post :reaction, params: { id: video.id, emotion_type: 0 }, format: :js
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(Video.with_count_like.find_by(id: video.id).count_like).to eq 1
      end
    end

    context "when like success but had liked" do
      let(:user){ create :user }
      let(:video){ create :video }
      let!(:emotion){ create :emotion, video: video, user: user, emotion_type: 0 }

      before do
        sign_in user
        post :reaction, params: { id: video.id, emotion_type: 0 }, format: :js
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(Video.with_count_like.find_by(id: video.id).count_like).to eq 0
      end
    end

    context "when like success but had disliked" do
      let(:user){ create :user }
      let(:video){ create :video }
      let!(:emotion){ create :emotion, video: video, user: user, emotion_type: 1 }

      before do
        sign_in user
        post :reaction, params: { id: video.id, emotion_type: 0 }, format: :js
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(Video.with_count_like.find_by(id: video.id).count_like).to eq 1
        expect(Video.with_count_like.find_by(id: video.id).count_dislike).to eq 0
      end
    end

    context "when dislike success" do
      let(:user){ create :user }
      let!(:video){ create :video }

      before do
        sign_in user
        post :reaction, params: { id: video.id, emotion_type: 1 }, format: :js
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(Video.with_count_like.find_by(id: video.id).count_dislike).to eq 1
      end
    end

    context "when reaction failed because authorized" do
      let!(:video){ create :video }

      before do
        post :reaction, params: { id: video.id, emotion_type: 0 }, format: :js
      end

      it do
        expect(response).to have_http_status(:found)
        expect(Video.with_count_like.find_by(id: video.id).count_like).to eq 0
      end
    end
  end
end
