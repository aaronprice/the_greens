class ReservationsController < ApplicationController

  before_filter :build_reservation_form, only: [:new, :create]

  def index
    @current_reservations = Reservation.this_week.collect{ |record| record.reserved_at.xmlschema }
  end

  def new
  end

  def create
    if @reservation_form.save
      login_as(@reservation_form.reservation.user)

      flash[:success] = "Great! See you on #{@reservation_form.reservation.reserved_at.strftime("%A at %l:%M%p")}"
      redirect_to reservations_path
    else
      flash[:error] = "Please fix the below errors and resubmit"
      render :new
    end
  end

private

  def build_reservation_form
    @reservation_form = ReservationForm.new(Reservation.new, allowed_params[:reservation_form], current_user)
  end

  def allowed_params
    params.permit(reservation_form: [:name, :email, :reserved_at])
  end
end