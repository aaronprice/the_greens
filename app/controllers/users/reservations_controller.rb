class Users::ReservationsController < ApplicationController

  before_filter :require_auth

  def destroy
    reservation = current_user.reservations.find(params[:id])
    reservation.destroy!

    flash[:success] = "Reservation successfully deleted."
    redirect_to user_path

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Reservation not found"
    redirect_to user_path
  end
end