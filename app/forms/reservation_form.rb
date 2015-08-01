class ReservationForm
  include ActiveModel::Model

  attr_accessor :name, :email, :reserved_at, :reservation, :current_user

  validates :name, :email, :reserved_at, presence: true
  validate :reservation_available

  def initialize(reservation, params = {}, current_user = nil)
    self.current_user = current_user

    self.reservation = reservation

    params = {} if params.nil?
    self.name = params.fetch(:name, current_user.try(:name))
    self.email = params.fetch(:email, current_user.try(:email))
    self.reserved_at = Time.zone.parse(params[:reserved_at]) if params[:reserved_at].present?
  end

  def new_record?
    true
  end

  def persisted?
    false
  end

  def save
    if self.valid?
      self.save_object
      self
    else
      false
    end
  end

  def save_object
    ActiveRecord::Base.transaction do

      # Ensure user
      user = User.find_or_initialize_by(email: self.email)
      user.name = self.name
      user.save

      # Create reservation
      self.reservation.user = user
      self.reservation.reserved_at = self.reserved_at
      self.reservation.save
    end
  end

  def reservation_available
    return true if self.reserved_at.blank?
    if Reservation.exists?(reserved_at: self.reserved_at.to_s(:db))
      errors.add(:reserved_at, "is already taken")
    end
  end

end