class JobFromDirectContact < Job
  validates :hourly_rate, presence: true
  validates :rate_type, inclusion: { in: ['hourly'], message: 'must be selected' }
end
