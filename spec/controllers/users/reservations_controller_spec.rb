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
      expect(flash[:error]).to eq("Reservation not found")
    end

    it "failure - within 1 hour of reservation" do
      # Set reserved time to within 1 hour from now
      # in this case 20 minutes to 40 minutes away.
      reservation.reserved_at = Time.at(20.minutes.from_now.to_i/(20*60)*(20*60))
      reservation.save!

      delete :destroy, { id: reservation.id }
      expect(response).to redirect_to(user_path)
      expect(flash[:error]).to eq("Reservation starts in less than 1 hour")
    end
  end

end