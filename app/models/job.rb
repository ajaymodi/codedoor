class Job < ActiveRecord::Base
  include HasRate

  belongs_to :client
  belongs_to :programmer
  has_many :job_messages, dependent: :destroy
  accepts_nested_attributes_for :job_messages

  validates :client_id, presence: true
  validates :programmer_id, presence: true
  validates :name, presence: true
  validates :rate, presence: true
  validates :availability, inclusion: { in: ['part-time', 'full-time'], message: 'must be selected' }
  validates :started_at, presence: true, if: Proc.new{|p| p.running? || p.finished?}
  validates :finished_at, presence: true, if: Proc.new{|p| p.finished? || p.disabled?}

  validate :client_and_programmer_are_different
  validate :rate_is_unchanged, unless: :has_not_or_has_just_started?
  validate :availability_is_unchanged, unless: :has_not_or_has_just_started?
  validate :finished_after_started, if: Proc.new{|p| p.started_at && p.finished_at}

  after_save :calculate_programmer_availability

  state_machine :state, initial: :has_not_started do
    before_transition to: :running do |job, transition|
      job.started_at = Time.now
    end

    before_transition to: [:finished, :disabled] do |job, transition|
      job.finished_at = Time.now
    end

    event :offer do
      transition has_not_started: :offered
    end

    event :cancel do
      transition offered: :canceled
    end

    event :decline do
      transition offered: :declined
    end

    event :start do
      transition offered: :running
    end

    event :finish do
      transition running: :finished
    end

    event :disable do
      transition all => :disabled
    end
  end

  def is_client?(user)
    raise 'Called is_client? for non-user' unless user.kind_of?(User)
    client.user == user
  end

  def other_user(user)
    raise 'Called other_user for non-user' unless user.kind_of?(User)
    (client.user == user) ? programmer.user : client.user
  end

  private

  def calculate_programmer_availability
    if finished? || disabled? || running?
      self.programmer.calculate_calculated_availability
      self.programmer.save!
    end
  end

  def client_and_programmer_are_different
    # NOTE: This would only throw an exception if the client or programmer are missing, but that's invalid
    begin
      errors.add(:programmer, 'must refer to a different user') if client.user == programmer.user
    rescue
    end
  end

  def has_not_or_has_just_started?
    state_was.nil? || state_was == 'has_not_started'
  end

  def rate_is_unchanged
    errors.add(:rate, 'must stay the same for the job') if rate_changed?
  end

  def availability_is_unchanged
    errors.add(:availability, 'must stay the same for the job') if availability_changed?
  end

  def finished_after_started
    errors.add(:finished_at, 'must come after time started at') if finished_at < started_at
  end

end
