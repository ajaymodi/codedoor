class JobFromApplication < Job
  has_one :job_listing

  validates :job_listing_id, presence: true
  validates :rate_type, inclusion: { in: ['hourly', 'fixed_price'], message: 'must be selected' }
  validates :hourly_rate, presence: true, if: :hourly?
  validates :fixed_rate, presence: true, if: :fixed_price?
end
