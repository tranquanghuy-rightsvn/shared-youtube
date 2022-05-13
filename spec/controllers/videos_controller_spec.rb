require "rails_helper"

RSpec.describe VideosController, type: :controller do
  describe "GET #new" do
    context "when get request success" do
      let(:user){ create :user }
      before do
        controller.instance_variable_set(:@current_user, user)
        get :new
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(assigns.keys.include?("video")).to be true
        expect(response).to render_template(:new)
      end
    end

    context "when get request failed" do
      before do
        controller.instance_variable_set(:@current_user, nil)
        get :new
      end

      it do
        byebug
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
