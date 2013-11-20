class JobListing < ActiveRecord::Base
  belongs_to :client

  validates :client_id, presence: true
  validates :title, presence: true
  validates :description, presence: true

  validates :suggested_rate_type, inclusion: { in: ['fixed_price', 'hourly'], message: 'must be selected' }

  validates :min_hours_per_week, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 40 }, if: :hourly?
  validates :max_hours_per_week, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 40 }, if: :hourly?
  validates :min_hourly_rate, numericality: { greater_than_or_equal_to: 23, less_than_or_equal_to: 1125 }, if: :hourly?
  validates :max_hourly_rate, numericality: { greater_than_or_equal_to: 23, less_than_or_equal_to: 1125 }, if: :hourly?

  validates :suggested_fixed_rate, presence: true, if: :fixed_price?
  validates :delivery_date, presence: true, if: :fixed_price?

  validates :visibility, inclusion: { in: ['public', 'codedoor'], message: 'must be selected' }

  validate :min_less_than_max, if: :hourly?

  validate :delivery_date_in_future, if: :fixed_price?

  before_validation :normalize_by_rate_type

  def hourly?
    suggested_rate_type == 'hourly'
  end

  def fixed_price?
    suggested_rate_type == 'fixed_price'
  end

  protected

  def min_less_than_max
    unless min_hours_per_week <= max_hours_per_week
      errors.add(:min_hours_per_week, 'must be less than the maximum hours per week')
    end
    unless min_hourly_rate <= max_hourly_rate
      errors.add(:min_hourly_rate, 'must be less than the maximum hourly rate')
    end
  end

  def delivery_date_in_future
    if delivery_date < Date.today
      errors.add(:delivery_date, 'must be in the future')
    end
  end

  def normalize_by_rate_type
    if fixed_price?
      self.min_hourly_rate = nil
      self.max_hourly_rate = nil
      self.min_hours_per_week = nil
      self.max_hours_per_week = nil
    elsif hourly?
      self.suggested_fixed_rate = nil
      self.delivery_date = nil
    end
  end
end
