require "rails_helper"

RSpec.describe User, type: :model do
  describe "relationships" do
    it do
      is_expected.to have_many(:videos)
      is_expected.to have_many(:emotions)
    end
  end

  describe "validations" do
    context "with email" do
      it do
        is_expected.to validate_presence_of(:email)
        is_expected.to allow_value("example123@gmail.com").for(:email)
        is_expected.not_to allow_value("example").for(:email)
      end
    end

    context "with password" do
      it do
        is_expected.to validate_presence_of(:password)
        is_expected.to validate_length_of(:password).is_at_least(6)
      end
    end
  end
end
