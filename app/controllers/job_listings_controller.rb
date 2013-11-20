class JobListingsController < ApplicationController
  before_filter :client_required, only: [:new, :create, :edit, :update]

  load_and_authorize_resource

  def index
    if user_signed_in?
      @job_listings = JobListing.where(visibility: :public)
    else
      @job_listings = JobListing
    end
    @job_listings = @job_listings.where('ended = false OR ended IS NULL')
  end

  def show
    @show_back_to_search = params[:search].present?
  end

  def new
    @job_listing = JobListing.new(client_id: current_user.client.id, visibility: :public)
  end

  def create
    @job_listing = JobListing.new(job_listing_params)
    @job_listing.client = current_user.client

    if @job_listing.save
      flash[:notice] = 'The job listing has been created.'
      redirect_to jobs_path
    else
      flash[:alert] = 'The job listing could not be created.'
      render :new
    end
  end

  def edit
  end

  def update
    @job_listing = JobListing.find(params[:id])
    if @job_listing.update(job_listing_params)
      flash[:notice] = 'The job listing has been updated.'
      redirect_to jobs_path
    else
      flash[:alert] = 'The job listing could not be updated.'
      render :edit
    end
  end

  protected

  def job_listing_params
    params.require(:job_listing).permit(:title, :description, :suggested_rate_type, :visibility, :min_hours_per_week, :max_hours_per_week, :min_hourly_rate, :max_hourly_rate, :suggested_fixed_rate, :ended, :'delivery_date(1i)', :'delivery_date(2i)', :'delivery_date(3i)')
  end
end
