require "rails_helper"

RSpec.describe UsersController, type: :controller do

  let(:user) { users(:default) }

  describe "GET show" do
    it "success" do
      login_as(user)

      get :show
      expect(response).to render_template(:show)
    end

    it "failure" do
      get :show
      expect(response).to redirect_to(new_session_path)
    end
  end
end