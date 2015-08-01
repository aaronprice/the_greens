class Reservation < ActiveRecord::Base

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================

  belongs_to :user

  # == Validations ==========================================================

  # == Scopes ===============================================================

  scope :this_week, -> {
    where("reservations.reserved_at >= :beginning_of_week AND reservations.reserved_at <= :end_of_week", {
      beginning_of_week: Time.now.at_beginning_of_week.to_s(:db),
      end_of_week: Time.now.at_end_of_week.to_s(:db)
    })
  }

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

end