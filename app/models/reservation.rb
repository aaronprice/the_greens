class Reservation < ActiveRecord::Base

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================

  belongs_to :site
  belongs_to :user

  # == Validations ==========================================================

  validates :site, presence: true

  # == Scopes ===============================================================

  default_scope { order("reservations.reserved_at ASC") }

  scope :future, -> { where("reservations.reserved_at >= CURRENT_TIMESTAMP") }

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  def self.for_period(from, to)
    where("reservations.reserved_at >= :from AND reservations.reserved_at <= :to", {
      from: from.to_s(:db),
      to: to.to_s(:db)
    })
  end

  def self.at_site(site)
    where(site_id: site.id)
  end

  # == Instance Methods =====================================================

  def is_within_one_hour?
    1.hour.from_now < self.reserved_at
  end

end