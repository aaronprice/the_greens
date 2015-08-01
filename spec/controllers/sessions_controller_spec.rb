require "rails_helper"

RSpec.describe SessionsController, type: :controller do

  let(:user) { users(:default) }

  it "GET new" do
    get :new
    expect(response).to render_template(:new)
  end

  describe "POST create" do
    it "success" do
      post :create, { email: user.email }
      expect(response).to redirect_to(user_path)
    end

    it "failure" do
      post :create
      expect(response).to render_template(:new)
      expect(flash[:error].present?).to eq(true)
    end
  end
end