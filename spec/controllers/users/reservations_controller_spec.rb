require "rails_helper"

RSpec.describe Users::ReservationsController, type: :controller do

  let(:reservation) { reservations(:default) }

  before { login_as(reservation.user) }

  describe "DELETE destroy" do
    it "success" do
      delete :destroy, { id: reservation.id }
      expect(response).to redirect_to(user_path)
      expect(flash[:success].present?).to eq(true)
    end

    it "failure" do
      delete :destroy, { id: "-invalid-" }
      expect(response).to redirect_to(user_path)
      expect(flash[:error].present?).to eq(true)
    end
  end

end