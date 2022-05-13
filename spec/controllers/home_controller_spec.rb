require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    context "when get request success" do
      let!(:video_1){ create :video }
      let!(:video_2){ create :video }
      let!(:video_3){ create :video }

      before{ get :index }

      it do
        expect(response).to have_http_status(:ok)
        expect(assigns["videos"]).to eq Video.includes(:user, :emotions).with_count_like.newest.page(1).per 5
        expect(assigns.keys.include?("user")).to be true
        expect(response).to render_template(:index)
      end
    end
  end
end
