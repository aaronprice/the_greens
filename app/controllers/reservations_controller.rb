class ReservationsController < ApplicationController

  before_filter :load_reservation_period, only: [:index]
  before_filter :build_reservation_form, only: [:new, :create]

  def index
    @current_reservations = Reservation.future.for_period(@period_from, @period_to).collect{ |record| record.reserved_at.xmlschema }
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

  def load_reservation_period
    params[:from] ||= Time.zone.now.at_beginning_of_week.to_s
    params[:to] ||= Time.zone.now.at_end_of_week.to_s

    @period_from = Time.zone.parse(params[:from])
    @period_to = Time.zone.parse(params[:to])
  end
end