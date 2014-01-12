class JobsController < ApplicationController
  before_filter :client_or_programmer_required, only: [:index, :edit, :create_message, :finish]
  before_filter :client_required, only: [:new, :create]
  before_filter :programmer_required, only: [:new_application, :create_application]

  before_filter :required_account_is_conditional, only: [:offer, :cancel, :start, :decline]

  load_and_authorize_resource except: [:create, :create_message, :offer, :start, :cancel, :decline, :finish, :new_application, :create_application]

  def index
    if current_user.client.present?
      @jobs_as_client = Job.where(client_id: current_user.client.id)
      @job_listings_as_client = JobListing.where(client_id: current_user.client.id)
    else
      @jobs_as_client = []
      @job_listings_as_client = []
    end
    @jobs_as_programmer = current_user.completed_programmer_account? ? Job.where(programmer_id: current_user.programmer.id) : []
  end

  def new
    @programmer = Programmer.find(params[:programmer_id])

    redirect_cannot_be_found if @programmer.unavailable?
    redirect_to_existing_job(@programmer, current_user.client)

    # NOTE: It should be JobFromDirectContact, but that would muck up the hidden parameters to be saved
    @job = Job.new(client_id: current_user.client.id, programmer_id: @programmer.id, hourly_rate: @programmer.hourly_rate, availability: @programmer.availability, rate_type: 'hourly')
  end

  def create
    @job = JobFromDirectContact.new(create_job_params)
    @programmer = @job.programmer
    redirect_cannot_be_found if @programmer.unavailable?

    @job.client_id = current_user.client.id
    @job.hourly_rate = @programmer.hourly_rate
    @job.rate_type = 'hourly'
    @job.availability = @programmer.availability
    @job.job_messages.first.sender_is_client = true if @job.job_messages.present?

    authorize! :create, @job
    create_job_or_message(offer_job_with_message(@job), @job.job_messages.first, :new)
  end

  def new_application
    @job_listing = JobListing.find(params[:job_listing_id])

    @programmer = current_user.programmer

    redirect_to_existing_job(@programmer, @job_listing.client)

    authorize! :read, @job_listing

    # NOTE: Only use JobFromApplication for additional validation rules on create
    @job = Job.new(client_id: @job_listing.client_id, programmer_id: @programmer.id, job_listing_id: @job_listing.id)

    @job.rate_type = @job_listing.suggested_rate_type
  end

  def create_application
    @job = JobFromApplication.new(create_job_application_params)
    @programmer = current_user.programmer
    @job_listing = JobListing.find(@job.job_listing_id)
    redirect_cannot_be_found if @programmer.unavailable?

    @job.programmer = @programmer
    @job.client = @job_listing.client
    @job.name = @job_listing.title
    @job.availability = @programmer.unavailable? ? 'part-time' : @programmer.availability

    authorize! :create, @job
    create_job_or_message(offer_job_with_message(@job), @job.job_messages.first, :new_application)
  end

  def edit
    @programmer = @job.programmer
  end

  def create_message
    @job = Job.find(params[:id])
    authorize! :update, @job
    @programmer = @job.programmer
    @job_message = JobMessage.new(create_message_params)
    @job_message.sender_is_client = @job.is_client?(current_user)
    @job.job_messages << @job_message

    create_job_or_message(offer_job_with_message(@job), @job_message, :edit)
  end

  def offer
    # The rate and availability gets locked at the time of offer
    state_change({direct_contact: :update_as_client, application: :update_as_programmer}, ->{@job.has_not_started?}, ->{@job.availability = @job.programmer.availability; @job.hourly_rate = @job.programmer.hourly_rate; @job.offer!}, :offered, 'The job has been offered.', 'The job could not be offered.')
  end

  def cancel
    state_change({direct_contact: :update_as_client, application: :update_as_programmer}, ->{@job.offered?}, ->{@job.cancel!}, :canceled, 'The job has been canceled.', 'The job could not be canceled.')
  end

  def start
    state_change({direct_contact: :update_as_programmer, application: :update_as_client}, ->{@job.offered?}, ->{@job.start!}, :started, 'The job has been started.', 'The job could not be started.')
  end

  def decline
    state_change({direct_contact: :update_as_programmer, application: :update_as_client}, ->{@job.offered?}, ->{@job.decline!}, :declined, 'The job has been declined.', 'The job could not be declined.')
  end

  def finish
    state_change({direct_contact: :update, application: :update}, ->{@job.offered? || @job.running?}, ->{@job.finish!}, :finished, 'The job is now finished.', 'The job could not be finished.')
  end

  private

  def create_job_or_message(job_offered, job_message, failure_template)
    if @job.save
      UserMailer.message_sent(@job.other_user(current_user), @job, job_message, current_user, job_offered).deliver
      flash[:notice] = job_offered ? 'The job has been offered.' : 'Your message has been sent.'
      redirect_to edit_job_path(@job)
    else
      flash[:alert] = job_offered ? 'The job could not be offered.' : 'Your message could not be sent.'
      render failure_template
    end
  end

  def required_account_is_conditional
    @job = Job.find(params[:id])
    if action_name == 'offer' || action_name == 'cancel'
      @job.kind_of?(JobFromDirectContact) ? client_required : programmer_required
    elsif action_name == 'start' || action_name == 'decline'
      @job.kind_of?(JobFromDirectContact) ? programmer_required : client_required
    end
  end

  def offer_job_with_message(job)
    if params[:'offer-contract'].present? && job.has_not_started? && (job.is_client?(current_user) != job.kind_of?(JobFromApplication))
      job.state = 'offered'
      job.started_at = Time.now
      return true
    end
    false
  end

  def state_change(permission_required_hash, state_required, action, action_name, success_message, failure_message)
    @job = Job.find(params[:id])
    permission_required = @job.kind_of?(JobFromApplication) ? permission_required_hash[:application] : permission_required_hash[:direct_contact]
    authorize! permission_required, @job
    if state_required.call
      action.call
      UserMailer.state_occurred_to_job(@job.other_user(current_user), @job, current_user, action_name).deliver
      flash[:notice] = success_message
    else
      flash[:alert] = failure_message
    end
    redirect_to action: :edit
  end

  def redirect_to_existing_job(programmer, client)
    existing_jobs = Job.where('programmer_id = ? AND client_id = ? AND (state = ? OR state = ? OR state = ?)', programmer.id, client.id, 'has_not_started', 'offered', 'running')
    redirect_to edit_job_path(existing_jobs.first) unless existing_jobs.empty?
  end

  def create_job_params
    params.require(:job).permit(:programmer_id, :name, job_messages_attributes: [:content])
  end

  def create_job_application_params
    params.require(:job).permit(:job_listing_id, :rate_type, :hourly_rate, :fixed_rate, job_messages_attributes: [:content])
  end

  def create_message_params
    params.require(:job_message).permit(:content)
  end

end
