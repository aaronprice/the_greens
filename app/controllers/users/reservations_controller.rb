class Users::ReservationsController < ApplicationController

  before_filter :require_auth

  def destroy
    reservation = current_user.reservations.find(params[:id])

    if reservation.is_within_one_hour?
      flash[:success] = "Reservation successfully deleted"
      reservation.destroy!
    else
      flash[:error] = "Reservation starts in less than 1 hour"
    end

    redirect_to user_path

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Reservation not found"
    redirect_to user_path
  end

end